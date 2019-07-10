------------------
-- Abgabe 4.2
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
-- Sequenzerkennung
------------------
-- Pinbelegung ---
-- Zustand 		LEDR7 - LEDR0  -> LEDs
-- Reset			KEY0				-> X
-- Clock 		KEY2 				-> clk
-- Ausgang		LEDG0				-> Y


LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY case_seq IS
PORT ( X : IN std_logic;
       clk: IN std_logic;
       rst : in std_logic;
       Y : OUT std_logic;
       LEDs : OUT std_logic_vector(8 downto 0)
     );
END case_seq;

ARCHITECTURE behavior OF case_seq IS  
	TYPE State_type IS (A, B, C, D, E, F, G, H, I);
	SIGNAL z_Q , z_D : State_type ; -- z_Q i s present state , z_D ←􏰀 is nexit state 
	SIGNAL yi : std_logic := '0';
	SIGNAL leds_i : std_logic_vector(8 downto 0) := "000000000";

	BEGIN


	PROCESS (z_Q) -- state table BEGIN
	BEGIN
		 case z_Q IS
			  WHEN A =>
					IF (X = '0') THEN z_D <= B;
					ELSE z_D <= F; 
					END IF;
			  WHEN B =>
					IF (X = '0') THEN z_D <= C;
					ELSE z_D <= F;
					END IF;
			  WHEN C =>
					IF (X = '0') THEN z_D <= D;
					ELSE z_D <= F;
					END IF;
			  WHEN D =>
					IF (X = '0') THEN z_D <= E;
					ELSE z_D <= F;
					END IF;
			  WHEN E =>
					IF (X = '0') THEN z_D <= E;
					ELSE z_D <= F;
					END IF;
			  WHEN F =>
					IF (X = '0') THEN z_D <= B;
					ELSE z_D <= G;
					END IF;
			  WHEN G =>
					IF (X = '0') THEN z_D <= B;
					ELSE z_D <= H;
					END IF;
			  WHEN H =>
					IF (X = '0') THEN z_D <= B;
					ELSE z_D <= I;
					END IF;
			  WHEN I =>
					IF (X = '0') THEN z_D <= B;
					ELSE z_D <= I;
					END IF;
		 END CASE;
		 
		 case z_Q IS
					WHEN A =>
						 leds_i <= "000000001";
					WHEN B =>
						 leds_i <= "000000010";
					WHEN C =>
						 leds_i <= "000000100";
					WHEN D =>
						 leds_i <= "000001000";
					WHEN E =>
						 leds_i <= "000010000";
					WHEN F =>
						 leds_i <= "000100000";
					WHEN G =>
						 leds_i <= "001000000";
					WHEN H =>
						 leds_i <= "010000000";
					WHEN I =>
						 leds_i <= "100000000";
			  END CASE;
	END PROCESS; --state table END

	PROCESS (clk, rst)
	BEGIN
		 if(rst = '0') then
			yi <= '0'; 
			z_Q <= A;
		 elsif(rising_edge(clk)) then
			  z_Q <= z_D;
			  if(z_D = I OR z_D = E) then
					yi <= '1';
			  else yi <= '0';
			  end if;
		 end if;
	END PROCESS;

	Y <= yi;
	LEDs <= leds_i;

END behavior;