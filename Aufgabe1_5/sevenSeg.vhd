------------------
-- Abgabe Ueb 4.1.5
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
-- Siebensegmentanzeige
------------------
-- Pinbelegung -- 
-- Number In		SW3 - SW0 -> num
-- Seg_Anzeige		HEX0 Pins -> segments
-- Select			SW 17     -> SEL
------------------

library ieee;
use ieee.std_logic_1164.all;

entity sevenSeg is
	port(
		num: in std_logic_vector(3 downto 0);
		SEL: in std_logic;
		segments: out std_logic_vector(6 downto 0)
	);
end sevenSeg;

architecture implementation of sevenSeg is
	signal outSig: std_logic_vector(6 downto 0);
	
begin
	process(num)
		begin
			if(SEL = '1')then
				outSig(6) <= num(3) OR (NOT(num(0)) AND num(1)) OR (NOT(num(2)) AND (NOT(num(0)) OR num(1))) OR (num(0) AND NOT(num(1)) AND num(2));
				outSig(5) <= NOT(num(2)) OR (NOT(num(0)) AND NOT(num(1)) AND num(2));
				outSig(4) <= NOT(num(1)) OR (num(0) AND NOT(num(2))) OR (NOT(num(0)) AND num(2));
				outSig(3) <= num(1) OR num(3) OR (num(0) AND num(2)) OR (NOT(num(0)) AND NOT(num(2)));
				outSig(2) <= (NOT(num(0)) AND NOT(num(2))) OR (num(1) AND num(2));
				outSig(1) <= num(2) OR num(3) OR (NOT(num(0)) AND NOT(num(2)) AND NOT(num(1)));
				outSig(0) <= num(2) OR num(1) OR num(3);
			else
				--Hier Funktionen fuer 4bit Zahlen einfuegen
				outSig(6) <= (NOT(num(0)) AND (NOT(num(2)) OR num(3) OR num(1))) OR (num(3) AND ((num(1) AND num(2)) OR (NOT(num(1)) AND NOT(num(2))))) OR (NOT(num(3)) AND ((num(1) AND NOT(num(2))) OR (num(0) AND NOT(num(1)) AND num(2))));
				outSig(5) <= (NOT(num(2)) AND (NOT(num(0)) OR NOT(num(3)))) OR (NOT(num(1)) AND ((num(0) AND num(3)) OR (NOT(num(0)) AND NOT(num(3)))));
				outSig(4) <= (num(0) AND (NOT(num(2)) OR NOT(num(1)))) OR (NOT(num(2)) AND num(3)) OR (NOT(num(3)) AND (NOT(num(1)) OR (NOT(num(0)) AND num(2))));
				outSig(3) <= (NOT(num(3)) AND (num(1) OR (NOT(num(0)) AND NOT(num(2))) OR (num(0) AND num(2)))) OR (NOT(num(1)) AND num(3)) OR (num(1) AND ((NOT(num(0)) AND num(2)) OR (num(0) AND NOT(num(2)))));
				outSig(2) <= (num(2) AND (num(1) OR num(3))) OR (NOT(num(0)) AND NOT(num(2))) OR (num(1) AND num(3));
				outSig(1) <= (NOT(num(2)) AND (num(3) OR (NOT(num(1)) AND NOT(num(0))))) OR (num(2) AND (NOT(num(3)) OR NOT(num(0)))) OR (num(1) AND num(3));
				outSig(0) <= num(1) OR (num(2) AND NOT(num(3))) OR (num(3) AND (NOT(num(2)) OR num(0)));
			end if; 
	
	end process;
	
	process (outSig)
	begin
		if (num = "0111") then 
			segments <= outSig;
		else 
			segments <= not outSig;
		end if;
	end process; 
	
end implementation;
