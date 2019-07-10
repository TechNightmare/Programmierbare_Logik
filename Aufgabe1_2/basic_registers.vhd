-------------------------
-- Abgabe ueb 4.1.2
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
-- PISO Register (basic_registers genannt wegen Toplevel entity)
-------------------------
library ieee; 
use ieee.std_logic_1164.all; 

entity basic_registers is 
	port ( 	CLK, CLR, LD 	: in std_logic; 
				D					: in std_logic_vector(3 downto 0);
				Q					: out std_logic);
end basic_registers; 

architecture behave_basic_registers of basic_registers is 
	
	signal Qi: std_logic_vector(3 downto 0) := "UUUU";  		
	signal Qo : std_logic := 'U'; 		
	
	begin
		
		basic_registers: process (CLK, CLR) is
		
			begin
				
				if (CLR = '1') then
					Qi <= "0000"; Qo <= '0';
				elsif (rising_edge(CLK) AND LD = '1') then    -- es können Datenempfangen werden Ausgang ist in Startzustand
					Qi <= D;
				elsif (rising_edge(CLK) AND LD = '0') then
						Qo <= Qi(0); Qi (2 downto 0) <= Qi (3 downto 1); Qi(3) <= '0';	
						
					 
				end if; 
				
		end process basic_registers; 
		Q <= Qo; 

end behave_basic_registers;