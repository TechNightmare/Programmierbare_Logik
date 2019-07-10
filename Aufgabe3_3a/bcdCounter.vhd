------------------------------------------------
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
------------------------------------------------

--
--CLK				Input		PIN_Y2
--segments1[6]	Output	PIN_G18
--segments1[5]	Output	PIN_F22
--segments1[4]	Output	PIN_E17
--segments1[3]	Output	PIN_L26
--segments1[2]	Output	PIN_L25
--segments1[1]	Output	PIN_J22
--segments1[0]	Output	PIN_H22
--segments2[6]	Output	PIN_M24
--segments2[5]	Output	PIN_Y22
--segments2[4]	Output	PIN_W21
--segments2[3]	Output	PIN_W22
--segments2[2]	Output	PIN_W25
--segments2[1]	Output	PIN_U23
--segments2[0]	Output	PIN_U24
--segments3[6]	Output	PIN_AA25
--segments3[5]	Output	PIN_AA26
--segments3[4]	Output	PIN_Y25
--segments3[3]	Output	PIN_W26
--segments3[2]	Output	PIN_Y26
--segments3[1]	Output	PIN_W27
--segments3[0]	Output	PIN_W28


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


ENTITY bcdCounter IS
    PORT(
        CLK: IN std_logic;
        segments1: out std_logic_vector(6 downto 0);
		segments2: out std_logic_vector(6 downto 0);
		segments3: out std_logic_vector(6 downto 0);
		changedled : out std_logic
        );
END bcdCounter;

ARCHITECTURE behavior OF bcdCounter is
signal out1 : integer := -1; 
signal out2, out3: integer := 0;
signal changed: std_logic := '0';
signal temp : std_logic := '0';

COMPONENT sevenSeg is
    PORT(
      num1: in integer;
		num2: in integer;
		num3: in integer;
		segments1: out std_logic_vector(6 downto 0);
		segments2: out std_logic_vector(6 downto 0);
		segments3: out std_logic_vector(6 downto 0)
    );
END COMPONENT;

begin

    dut: sevenSeg PORT MAP(num1 => out1, num2 => out2, num3 => out3, segments1 => segments1,
                           segments2 => segments2, segments3 => segments3);

    process(CLK)
    VARIABLE count : INTEGER RANGE 0 TO 50000000 := 0;
    begin
        if(rising_edge(CLK)) then
            count := count +1;
            if(count = 50000000)then
                changed <= not(changed);
					 count := 0;
					 
					 if(out1 < 9) then
					   out1 <= out1 +1;
					 elsif(out2 < 9) then
						out1 <= 0;
						out2 <= out2 +1;
				    elsif(out3 < 9) then
						out1 <= 0;
						out2 <= 0;
						out3 <= out3 +1;
				    else
						out1 <= 0;
						out2 <= 0;
						out3 <= 0;
				    end if;
            end if;
        end if;
    end process;
	 
	 changedled <= changed;
	 
end behavior;
