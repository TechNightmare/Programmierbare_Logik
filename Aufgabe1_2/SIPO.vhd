-------------------------
-- Abgabe ueb 4.1.2
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
-- SIPO Register (basic_registers genannt wegen Toplevel entity)
-------------------------
library ieee; 
use ieee.std_logic_1164.all; 

entity SIPO is 
	port ( 	CLK, CLR, D : in std_logic; 
				Q			: out std_logic_vector(3 downto 0));
end SIPO; 

architecture behave_SIPO of SIPO is 
	
	signal Qi: std_logic_vector(3 downto 0) := "UUUU"; 
	signal Qo: std_logic_vector(3 downto 0) := "UUUU"; 		
	signal cur_out : std_logic_vector(1 downto 0) := "00";
	
	begin
		
		SIPO: process (CLK, CLR) is
		
			begin
				
				if (CLR = '1') then
					Qi <= "0000"; Qo <= "0000";
				elsif (rising_edge(CLK)) then    -- es können Datenempfangen werden Ausgang ist in Startzustand
					case cur_out is
						when "00" => Qi(0) <= D; cur_out <= "01";
						when "01" => Qi(1) <= D; cur_out <= "10";
						when "10" => Qi(2) <= D; cur_out <= "11";
						when "11" => Qi(3) <= D; cur_out <= "00";
						when OTHERS => Q <= "0000"; 
					end case; 
				elsif (falling_edge(CLK) and cur_out = "00") then
					Qo <= Qi; 
				end if; 
				
		end process SIPO; 
		Q <= Qo;

end behave_SIPO;