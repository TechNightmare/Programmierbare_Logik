-------------------------
-- Abgabe ueb 4.1.2
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
-- SISO Register
-------------------------
library ieee; 
use ieee.std_logic_1164.all; 

entity SISO is 
	port ( 	CLK, CLR, D, LD : in std_logic; 
				Q			: out std_logic_vector(3 downto 0));
end SISO; 

architecture behave_siso of SISO is 
	
	signal Qi: std_logic_vector(3 downto 0) := "UUUU"; 
	signal Qo: std_logic_vector(3 downto 0) := "UUUU"; 		
	
	begin
		
		SISO: process (CLK, CLR) is
		
			begin
				
				if (CLR = '1') then
					Qi <= "0000"; Qo <= "0000";
				elsif (rising_edge(CLK) AND LD = '1') then
					Qi (3 downto 1) <= Qi (2 downto 0); Qi(0) <= D; 
				elsif (falling_edge(CLK)) then
					Qo <= Qi; 
				end if; 
				
		end process SISO; 
		
		Q <= Qo; 

end behave_siso;