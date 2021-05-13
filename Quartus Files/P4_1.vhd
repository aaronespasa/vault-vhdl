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
	SIGNAL VALID_INPUT, Q0, Q1: STD_LOGIC;
	SIGNAL counter: INTEGER IN RANGE 0 TO 9;
	SIGNAL EoC: STD_LOGIC;
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

	-- Counter for 10 clock cycles
	PROCESS(clk, reset)
	BEGIN
		IF reset = '1' THEN			--High profile reset
			VALID_INPUT <= '0';
		ELSIF CLK'EVENT AND CLK='1' THEN
			-- It always goes up
			IF counter = 9 THEN
				counter <= 0;
				EoC <= '1';
			ELSE
				counter <= counter + 1;
				EoC <= '0';
		END IF;
	END PROCESS;

	
END practica;

-- SIGNAL Cuenta: UNSIGNED (3 downto 0); 
-- BEGIN
-- 	PROCESS (CLK,RESET)
-- 	BEGIN
-- 			IF RESET ='1' THEN
-- 			Cuenta<=(others => '0');
-- 			ELSIF (CLK'event) and (CLK='1') THEN
-- 				IF CE='1' THEN
-- 					IF UP_DOWN='0' THEN
-- 					Cuenta<= Cuenta+1;
-- 					ELSE
-- 					Cuenta<= Cuenta-1;
-- 					END IF;
-- 				END IF;
		
-- 			END IF;
-- 	END PROCESS;
-- Q<= Cuenta;
-- Carry_out <= '1' WHEN (Cuenta="1111" AND UP_DOWN='0') OR (Cuenta="0000" AND UP_DOWN='1') 
-- ELSE '0';

end practica;