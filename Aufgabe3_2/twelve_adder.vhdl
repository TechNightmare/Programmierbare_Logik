library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity twelve_adder is
  port(
    first_num, second_num :   IN  std_logic_vector(11 downto 0);
    erg_vector            :   OUT std_logic_vector(11 downto 0)
  );
end entity;

architecture calc of twelve_adder is
  signal temp : std_logic_vector(11 downto 0);
  begin
    process (first_num, second_num)
      begin
        temp <= first_num + second_num;
    end process;

    erg_vector <= temp(11 downto 0);

end calc;
