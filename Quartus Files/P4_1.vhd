--Práctica 3_1 Electronica Digital
-- Analisis y Simulación de Un Circuito Secuencial Síncrono
Library ieee;
use  ieee.std_logic_1164.all;
use  ieee.numeric_std.all;
ENTITY P3_1 IS
	PORT(
	CLK:IN STD_LOGIC;
	CE: IN STD_LOGIC;
	RESET:IN STD_LOGIC;
	UP_DOWN: IN STD_LOGIC;
	Carry_out: Out STD_LOGIC;
	Q: OUT UNSIGNED( 3 DOWNTO 0)
	);
END P3_1;
ARCHITECTURE practica of P3_1 IS
SIGNAL Cuenta: UNSIGNED (3 downto 0); 
BEGIN
	PROCESS (CLK,RESET)
	BEGIN
			IF RESET ='1' THEN
			Cuenta<=(others => '0');
			ELSIF (CLK'event) and (CLK='1') THEN
				IF CE='1' THEN
					IF UP_DOWN='0' THEN
					Cuenta<= Cuenta+1;
					ELSE
					Cuenta<= Cuenta-1;
					END IF;
				END IF;
		
			END IF;
	END PROCESS;
Q<= Cuenta;
Carry_out <= '1' WHEN (Cuenta="1111" AND UP_DOWN='0') OR (Cuenta="0000" AND UP_DOWN='1') 
ELSE '0';
end practica;