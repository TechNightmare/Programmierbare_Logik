library ieee;
use ieee.std_logic_1164.all;

entity nibbleCheck is
    port(
        twoNibble : in std_logic_vector(7 downto 0);
        outTwoNibble : out std_logic_vector(7 downto 0)
    );
end nibbleCheck;

architecture behavior of nibbleCheck is

signal out_sig : std_logic_vector (7 downto 0);

begin

    process(twoNibble)
	   variable nibble1, nibble2 : std_logic_vector(3 downto 0) := (others => '0');
      begin
		
		nibble1 := twoNibble(7 downto 4);
		nibble2 := twoNibble(3 downto 0);
  		

      case nibble1 is
        when "1010" => nibble1 := "0000";
        when "1011" => nibble1 := "0001";
        when "1100" => nibble1 := "0010";
        when "1101" => nibble1 := "0011";
        when "1110" => nibble1 := "0100";
        when "1111" => nibble1 := "0101";
        when others => nibble1 := nibble1;
  		end case;

      case nibble2 is
        when "1010" => nibble2 := "0000";
        when "1011" => nibble2 := "0001";
        when "1100" => nibble2 := "0010";
        when "1101" => nibble2 := "0011";
        when "1110" => nibble2 := "0100";
        when "1111" => nibble2 := "0101";
        when others => nibble2 := nibble2;
  		end case;
		
		out_sig(7 downto 4) <= nibble1;
		out_sig(3 downto 0) <= nibble2; 

    end process;

	outTwoNibble <= out_sig;

end behavior;
