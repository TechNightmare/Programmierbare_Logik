------------------------------------------------
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity sevenSeg is
	port(
		num: in std_logic_vector(3 downto 0);
		segments: out std_logic_vector(6 downto 0)
	);
end sevenSeg;

architecture implementation of sevenSeg is
	signal outSig: std_logic_vector(6 downto 0);
	
begin
	process(num)
		begin
			case num is
				when "0000" => outSig <= "0000001";
				when "0001" => outSig <= "1001111";
				when "0010" => outSig <= "0010010";
				when "0011" => outSig <= "0000110";
				when "0100" => outSig <= "1001100";
				when "0101" => outSig <= "0100100";
				when "0110" => outSig <= "0100000";
				when "0111" => outSig <= "0001111";
				when "1000" => outSig <= "0000000";
				when "1001" => outSig <= "0000100";
				when others => outSig <= "0000001";
			end case;
	end process;
	segments <= outSig;
end implementation;
