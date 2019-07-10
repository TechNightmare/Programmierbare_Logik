------------------------------------------------
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
------------------------------------------------

--position[2]		Input		PIN_Y23			-- Positionscodierung fuer Setten der Zeit
--position[1]		Input		PIN_Y24
--position[0]		Input		PIN_AA22
--presetting[3]	Input		PIN_AA23			-- Eingaben der Werte fuer Zeitposition
--presetting[2]	Input		PIN_AA24
--presetting[1]	Input		PIN_AB23
--presetting[0]	Input		PIN_AB24
--reset				Input		PIN_M23			-- Reset und Mode fuer Setting der Uhr
--segments1[6]	Output	PIN_AA25			-- 7 Segment Anzeige
--segments1[5]	Output	PIN_AA26
--segments1[4]	Output	PIN_Y25
--segments1[3]	Output	PIN_W26
--segments1[2]	Output	PIN_Y26
--segments1[1]	Output	PIN_W27
--segments1[0]	Output	PIN_W28
--segments2[6]	Output	PIN_V21
--segments2[5]	Output	PIN_U21
--segments2[4]	Output	PIN_AB20
--segments2[3]	Output	PIN_AA21
--segments2[2]	Output	PIN_AD24
--segments2[1]	Output	PIN_AF23
--segments2[0]	Output	PIN_Y19
--segments3[6]	Output	PIN_AB19
--segments3[5]	Output	PIN_AA19
--segments3[4]	Output	PIN_AG21
--segments3[3]	Output	PIN_AH21
--segments3[2]	Output	PIN_AE19
--segments3[1]	Output	PIN_AF19
--segments3[0]	Output	PIN_AE18
--segments4[6]	Output	PIN_AD18
--segments4[5]	Output	PIN_AC18
--segments4[4]	Output	PIN_AB18
--segments4[3]	Output	PIN_AH19
--segments4[2]	Output	PIN_AG19
--segments4[1]	Output	PIN_AF18
--segments4[0]	Output	PIN_AH18
--segments5[6]	Output	PIN_AA17
--segments5[5]	Output	PIN_AB16
--segments5[4]	Output	PIN_AA16
--segments5[3]	Output	PIN_AB17
--segments5[2]	Output	PIN_AB15
--segments5[1]	Output	PIN_AA15
--segments5[0]	Output	PIN_AC17
--segments6[6]	Output	PIN_AD17
--segments6[5]	Output	PIN_AE17
--segments6[4]	Output	PIN_AG17
--segments6[3]	Output	PIN_AH17
--segments6[2]	Output	PIN_AF17
--segments6[1]	Output	PIN_AG18
--segments6[0]	Output	PIN_AA14
--start				Input		PIN_N21			-- Start Btn


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY clock IS
    PORT(
        CLK: IN std_logic;
        position : IN std_logic_vector(2 downto 0);        --Ziffer auswaehlen
        presetting : IN std_logic_vector(3 downto 0);      --BCD Ziffer
        start       : IN std_logic;                        --Uhr laufen lassen
        reset       : IN std_logic;                        --Uhr auf 000000 zuruecksetzen
        segments1, segments2, segments3, segments4, segments5, segments6: out std_logic_vector(6 downto 0);
		changedled : out std_logic
        );
END clock;

ARCHITECTURE behavior OF clock is
signal out1 : integer := -1; 
signal out2, out3, out4, out5, out6 : integer := 0;
signal changed: std_logic := '0';
signal temp : std_logic := '0';

COMPONENT sevenSeg is
    PORT(
        num: in integer;
	    segments: out std_logic_vector(6 downto 0)
    );
END COMPONENT;

begin

    dut1: sevenSeg PORT MAP(num => out1, segments => segments1); -- sec einer
    dut2: sevenSeg PORT MAP(num => out2, segments => segments2); -- sec zehner
    dut3: sevenSeg PORT MAP(num => out3, segments => segments3); -- min einer                      
    dut4: sevenSeg PORT MAP(num => out4, segments => segments4); -- min zehner                       
    dut5: sevenSeg PORT MAP(num => out5, segments => segments5); -- std einer                       
    dut6: sevenSeg PORT MAP(num => out6, segments => segments6); -- std zehner                       
    process(CLK, reset)
    VARIABLE count : INTEGER RANGE 0 TO 500000 := 0;
    VARIABLE run   : BOOLEAN := false;
    begin
        if(reset = '0') then
            run := false;
            out1 <= 0;
            out2 <= 0;
            out3 <= 0;
            out4 <= 0;
            out5 <= 0;
            out6 <= 0;
        elsif (start = '0') then 
            run := true;
        elsif(run = false) then
            case position is
                when "000" => out1 <= to_integer(unsigned(presetting));
                when "001" => out2 <= to_integer(unsigned(presetting));
                when "010" => out3 <= to_integer(unsigned(presetting));
                when "011" => out4 <= to_integer(unsigned(presetting));
                when "100" => out5 <= to_integer(unsigned(presetting));
                when others => out6 <= to_integer(unsigned(presetting));
            end case;
        elsif(rising_edge(CLK) AND run) then
            count := count +1;
            if(count = 500000)then
                changed <= not(changed);
                     count := 0;
                     --sec einer
					 if(out1 < 9) then
                       out1 <= out1 +1;
                     --sec zehner
					 elsif(out2 < 5) then
						out1 <= 0;
                        out2 <= out2 +1;
                    --min einer
				    elsif(out3 < 9) then
						out1 <= 0;
						out2 <= 0;
                        out3 <= out3 +1;
                    --min zehner
                    elsif(out4 < 5) then
                        out1 <= 0;
                        out2 <= 0;
                        out3 <= 0;
                        out4 <= out4 +1;
                    --std einer
                    elsif(out5 < 3) then
                        out1 <= 0;
                        out2 <= 0;
                        out3 <= 0;
                        out4 <= 0;
                        out5 <= out5 +1;
                    --std zehner
                    elsif(out6 < 2)then
                        out1 <= 0;
                        out2 <= 0;
                        out3 <= 0;
                        out4 <= 0;
                        out5 <= 0;
                        out6 <= out6 +1;   
				    else
						out1 <= 0;
						out2 <= 0;
                        out3 <= 0;
                        out4 <= 0;
                        out5 <= 0;
                        out6 <= 0;
				    end if;
            end if;
        end if;
    end process;
	 
	 changedled <= changed;
	 
end behavior;
