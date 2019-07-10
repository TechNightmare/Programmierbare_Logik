--------------------------
-- Abgabe Ubueng 4.1.1
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
-- Einfaches Register
--------------------------
library ieee; 
use ieee.std_logic_1164.all; 


ENTITY simple_register IS
	port ( 	LD, CLR, CLK, D 	: in std_logic; 
				Q 						: out std_logic); 
end simple_register; 

architecture behave of simple_register is

	begin

		process (CLR, CLK) 
			
			begin
				
				if (CLR = '1') then
					Q <= '0';
				elsif (rising_edge (CLK) AND LD = '1') then
					Q <= D; 
				end if;
		
		end process;

end behave; 