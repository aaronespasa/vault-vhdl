--Pr�ctica 3_1 Electronica Digital
-- Analisis y Simulaci�n de Un Circuito Secuencial S�ncrono
Library ieee;
use  ieee.std_logic_1164.all;
use  ieee.numeric_std.all;

-- PASSWORD: 298

ENTITY P4_1 IS
	PORT(
		data: 	  IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		valid: 	  IN STD_LOGIC;
		reset: 	  IN STD_LOGIC;
		clk: 	  IN STD_LOGIC;
		unlock:   OUT STD_LOGIC;
		sequence: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
END P4_1;
ARCHITECTURE practica of P4_1 IS
	TYPE state_t IS (s0, v1, v2, w1, w2, waiting, unlocked);
	SIGNAL state, next_state: state_t; 
	SIGNAL VALID_INPUT, Q0, Q1: STD_LOGIC;
	SIGNAL timer: INTEGER RANGE 0 TO 9;
	SIGNAL EoC: STD_LOGIC;
	SIGNAL Enable_timer: STD_LOGIC;
	SIGNAL Enable_sec: STD_LOGIC;
	SIGNAL sec_aux: STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN 
	--Edge detector Description	
	PROCESS (clk, reset)
	BEGIN 
		IF reset = '1' THEN			--High profile reset
			VALID_INPUT <= '0';
		ELSIF CLK'EVENT AND CLK='1' THEN
			Q1 <= Q0;	
			Q0 <= valid;
			VALID_INPUT <= Q0 AND NOT(Q1);
		END IF;
	END PROCESS;

	
	--Moore Machine (Based on state transition graph)
	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			state <= s0;
		ELSIF CLK'EVENT AND CLK='1' THEN
			state <= next_state;
		END IF;
	END PROCESS;

	PROCESS(state, data, VALID_INPUT, EoC)
	BEGIN
	CASE STATE IS
		WHEN s0 =>
			Enable_sec <= '0';
			Enable_timer <= '0'; 
			
			IF data = "0010" AND VALID_INPUT = '1' AND EoC = '0' THEN
				-- The first digit is correct
				next_state <= v1;
			ELSIF data /= "0010" AND VALID_INPUT = '1' AND EoC = '0' THEN
				-- The first digit is incorrect
				next_state <= w1;
			ELSE
				next_state <= s0;
			END IF;
		WHEN v1 => 
			Enable_sec <= '1';
			Enable_timer <= '0'; 

			IF data = "1001" AND VALID_INPUT = '1' AND EoC = '0' THEN
				-- The second digit is correct
				next_state <= v2;
			ELSIF (data /= "1001" OR data /= "1111") AND VALID_INPUT = '1' AND EoC = '0' THEN
				-- The second digit is incorrect
				next_state <= w2;
			ELSE
				next_state <= v1;
			END IF;
		WHEN v2 =>
			Enable_sec <= '1';
			Enable_timer <= '0'; 

			IF data = "1000" AND VALID_INPUT = '1' AND EoC = '0' THEN
				-- The third digit is correct
				next_state <= unlocked;
			ELSIF (data /= "1000" OR data /= "1111") AND VALID_INPUT = '1' AND EoC = '0' THEN
				-- The third digit is incorrect
				next_state <= waiting; 
			ELSE
				next_state <= v2;
			END IF;
		WHEN w1 => 
		 	Enable_sec <= '0';
			Enable_timer <= '0'; 

			IF data /= "1111" AND VALID_INPUT = '1' AND EoC = '0' THEN
				-- The second digit is incorrect
				next_state <= w2;
			ELSE
				next_state <= w1;
			END IF;
		WHEN w2 =>
			Enable_sec <= '0';
			Enable_timer <= '0';

			IF data /= "1111" AND VALID_INPUT = '1' AND EoC = '0' THEN
				-- The third digit is incorrect
				next_state <= waiting;
			ELSE
				next_state <= w2;
			END IF;
		WHEN waiting =>
			-- Waiting for 10 cycles of clock
			Enable_sec <= '0';
			Enable_timer <= '1';
			
			IF EoC = '1' THEN
				next_state <= s0;
			ELSE
				next_state <= waiting;
			END IF;
			
		WHEN unlocked =>
			-- Waiting for close signal
			Enable_sec <= '0';
			Enable_timer <= '0';

			IF data = "1111" AND EoC = '0' THEN
				next_state <= s0;
			ELSE
				next_state <= unlocked;
			END IF;
		END CASE;
	END PROCESS;

	
	-- timer for 10 clock cycles
	PROCESS(clk)
	BEGIN
		IF CLK'EVENT AND CLK='1' THEN
			IF Enable_timer = '1' THEN
				-- It always goes up
				IF timer = 9 THEN
					timer <= 0;
					EoC <= '1';
				ELSE
					timer <= timer + 1;
					EoC <= '0';
				END IF;
			END IF;
		END IF;
	END PROCESS;

	
	--Shift register
	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN
			sec_aux <= "000";
		ELSIF CLK'EVENT AND CLK='1' THEN
			IF sec_aux = "111" THEN
				unlock <= '1';
			ELSE
				unlock <='0';
				IF Enable_sec = '1' THEN
					sec_aux <= Enable_sec & sec_aux(2 DOWNTO 1);
				ELSE
					--Append 0 to the sequence
					sec_aux <= Enable_sec & sec_aux(2 DOWNTO 1);	
				END IF;
			END IF;
		END IF;	
	END PROCESS;
	sequence <= sec_aux;		
END practica;