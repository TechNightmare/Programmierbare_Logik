--------------------------
-- Abgabe Ubueng 4.1.1
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
-- Generisches Register
--------------------------
library ieee; 
use ieee.std_logic_1164.all; 


ENTITY generic_register IS
	generic (n : integer := 4);
	
	port ( 	CLR, CLK			 	: in std_logic; 
				LD, D					: in std_logic_vector(n-1 downto 0); 
				Q 						: out std_logic_vector(n-1 downto 0)); 
end generic_register; 

architecture behave of generic_register is

	signal Qi : std_logic_vector(n-1 downto 0) := (others => 'U'); 
	

	begin

		process (CLR, CLK) 
			
			begin
				
				if (CLR = '1') then
					Qi <= (others => '0');
				elsif (rising_edge (CLK)) then
					for i in 0 to n loop
						if (LD(i) = '1') then
							Q(i) <= D(i);
						end if;
					end loop;
				end if;
		
		end process;
		
		Q <= Qi; 

end behave; 