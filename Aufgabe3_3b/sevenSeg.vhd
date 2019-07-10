library ieee;
use ieee.std_logic_1164.all;

entity sevenSeg is
	port(
		num: in integer;
		segments: out std_logic_vector(6 downto 0)
	);
end sevenSeg;

architecture implementation of sevenSeg is
	
begin
	process(num)
		begin
			case num is
				when 0 => segments <= "0000001";
				when 1 => segments <= "1001111";
				when 2 => segments <= "0010010";
				when 3 => segments <= "0000110";
				when 4 => segments <= "1001100";
				when 5 => segments <= "0100100";
				when 6 => segments <= "0100000";
				when 7 => segments <= "0001111";
				when 8 => segments <= "0000000";
				when 9 => segments <= "0000100";
				when others => segments <= "0000001";
			end case;
	end process;
end implementation;
