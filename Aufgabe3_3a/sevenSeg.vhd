------------------------------------------------
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity sevenSeg is
	port(
		num1: in integer;
		num2: in integer;
		num3: in integer;
		segments1: out std_logic_vector(6 downto 0);
		segments2: out std_logic_vector(6 downto 0);
		segments3: out std_logic_vector(6 downto 0)
	);
end sevenSeg;

architecture implementation of sevenSeg is
	
begin
	process(num1)
		begin
			case num1 is
				when 0 => segments1 <= "0000001";
				when 1 => segments1 <= "1001111";
				when 2 => segments1 <= "0010010";
				when 3 => segments1 <= "0000110";
				when 4 => segments1 <= "1001100";
				when 5 => segments1 <= "0100100";
				when 6 => segments1 <= "0100000";
				when 7 => segments1 <= "0001111";
				when 8 => segments1 <= "0000000";
				when 9 => segments1 <= "0000100";
				when others => segments1 <= "0000001";
			end case;
	end process;
	process(num2)
		begin
			case num2 is
				when 0 => segments2 <= "0000001";
				when 1 => segments2 <= "1001111";
				when 2 => segments2 <= "0010010";
				when 3 => segments2 <= "0000110";
				when 4 => segments2 <= "1001100";
				when 5 => segments2 <= "0100100";
				when 6 => segments2 <= "0100000";
				when 7 => segments2 <= "0001111";
				when 8 => segments2 <= "0000000";
				when 9 => segments2 <= "0000100";
				when others => segments2 <= "0000001";
			end case;
	end process;
	process(num3)
		begin
			case num3 is
				when 0 => segments3 <= "0000001";
				when 1 => segments3 <= "1001111";
				when 2 => segments3 <= "0010010";
				when 3 => segments3 <= "0000110";
				when 4 => segments3 <= "1001100";
				when 5 => segments3 <= "0100100";
				when 6 => segments3 <= "0100000";
				when 7 => segments3 <= "0001111";
				when 8 => segments3 <= "0000000";
				when 9 => segments3 <= "0000100";
				when others => segments3 <= "0000001";
			end case;
	end process;
end implementation;
