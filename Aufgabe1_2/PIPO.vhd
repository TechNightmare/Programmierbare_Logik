-------------------------
-- Abgabe ueb 4.1.2
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
-- PIPO Register
-------------------------
library ieee; 
use ieee.std_logic_1164.all; 

entity PIPO is 
	port ( 	CLK, CLR, LD : in std_logic; 
				D			: in std_logic_vector(3 downto 0); 
				Q			: out std_logic_vector(3 downto 0));
end PIPO; 

architecture behave_pipo of PIPO is 
	
	signal Qi: std_logic_vector(3 downto 0) := "UUUU"; 
	signal Qo: std_logic_vector(3 downto 0) := "UUUU"; 		
	
	begin
		
		PIPO: process (CLK, CLR) is
		
			begin
				
				if (CLR = '1') then
					Qi <= "0000"; Qo <= "0000";
				elsif (rising_edge(CLK) AND LD = '1') then
					Qi <= D; 
				elsif (falling_edge(CLK)) then
					Qo <= Qi; 
				end if; 
				
		end process; 
		
		Q <= Qo; 

end behave_pipo;