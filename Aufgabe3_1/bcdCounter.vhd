library ieee;
use ieee.std_logic_1164.all;

ENTITY bcdCounter IS
    PORT(bcd, gray, aiken: OUT std_logic_vector(3 downto 0);
        CLK: IN std_logic);
END bcdCounter;

ARCHITECTURE behavior OF bcdCounter is
signal counter: integer := -1;

begin
    process(CLK)
    begin
        if(rising_edge(CLK)) then
            if(counter >= 9) then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    process(counter)
    begin
        case(counter) is
            when 0 => bcd <= "0000"; aiken <= "0000"; gray <= "0000";
            when 1 => bcd <= "0001"; aiken <= "0001"; gray <= "0001";  
            when 2 => bcd <= "0010"; aiken <= "0010"; gray <= "0011";
            when 3 => bcd <= "0011"; aiken <= "0011"; gray <= "0010";
            when 4 => bcd <= "0100"; aiken <= "0100"; gray <= "0110";
            when 5 => bcd <= "0101"; aiken <= "1011"; gray <= "0111";
            when 6 => bcd <= "0110"; aiken <= "1100"; gray <= "0101";
            when 7 => bcd <= "0100"; aiken <= "1101"; gray <= "0100";
            when 8 => bcd <= "1000"; aiken <= "1110"; gray <= "1100";
            when 9 => bcd <= "1001"; aiken <= "1111"; gray <= "1101";
            when others => bcd <= "0000"; aiken <= "0000"; gray <= "0000";
        end case ;
    end process;
end behavior;
