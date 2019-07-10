------------------
-- Abgabe 4.1.4
-- Gruppe Frank Ehlert, Dawid Kohl, Paul Wagner
-- Arithmetik
------------------

-- Pinbelegung --
-- Select   SW17 -> SEL
-- Reset 	KEY0 -> RST
-- Zahl 1	SW3 - SW0 -> in_vecX
-- Zahl 2   SW8 - SW5 -> in_vecY
-- Carry    SW10 -> CARRY
-- Clock    KEY2 -> CLK
-- Ergebnis LED3 - LED0 -> out_vec

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity calc is
    port(CLK, RST, CARRY, SEL: in std_logic;
        in_vecX: in std_logic_vector(3 downto 0);
        in_vecY: in std_logic_vector(3 downto 0);
        out_vec: out std_logic_vector(3 downto 0));
end calc;

architecture calcImp of calc is
    signal outSig: std_logic_vector(3 downto 0) := "0000";
    signal carry_sig: std_logic := CARRY;
	 signal position: integer := 0;

begin
    process(CLK, RST, position, SEL)
	 variable AB: std_logic := '0';
	 variable y: std_logic_vector(3 downto 0) := in_vecY;
        begin
            if(RST = '0')then
                outSig <= "0000"; carry_sig <= CARRY; position <= 0;
			elsif(position > 4)then
						position <= 0;
						outSig <= "0000"; carry_sig <= CARRY;
			elsif(rising_edge(CLK) and (SEL = '1'))then
				-- Subtrahierer
				y := not(in_vecY) + 1;
				AB := in_vecX(position) XOR y(position);
				outSig(position) <= AB XOR carry_sig;
				carry_sig <= (in_vecX(position) AND y(position)) OR (carry_sig AND AB);
				position <= position + 1; 
            elsif(rising_edge(CLK) and (SEL = '0'))then
				-- Addierer
                AB := in_vecX(position) XOR in_vecY(position);
				outSig(position) <= AB XOR carry_sig;
				carry_sig <= (in_vecX(position) AND in_vecY(position)) OR (carry_sig AND AB);
				position <= position + 1; 
			end if;
	end process;
	out_vec <= outSig;

end calcImp;