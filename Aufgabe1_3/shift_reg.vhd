------------------
-- Abgabe 4.1.3
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
-- Universalregister
------------------
-- Pinbelegung -- 
-- Seriell In 		SW12           -> ser_IN
-- Clock				KEY2           -> clk
-- Reset				KEY0           -> rst
-- Parallel IN 	SW17 - SW14    -> par_IN
-- Mode Select		SW1 - SW 0     -> choice
-- Parallel OUT	LEDG3 - LEDG0-> par_OUT


library IEEE;
use IEEE.std_logic_1164.all;

ENTITY shift_reg IS
    PORT(
        ser_IN, clk, rst : IN std_logic;
        par_IN : IN std_logic_vector(3 downto 0);
        choice : IN std_logic_vector(1 downto 0);
		  par_OUT : OUT std_logic_vector(3 downto 0)
        
    );
END shift_reg;

ARCHITECTURE behavior OF shift_reg IS
    SIGNAL tmp : std_logic_vector(3 downto 0);

    BEGIN

    PROCESS(clk, rst)
        BEGIN
        --RST Signal einfuegen
		  IF (rst = '0') then
				tmp <= "0000";
        ELSIF(clk'event and clk = '1') then
            case choice IS  
                when "00" =>                           -- Parrallel Laden
                    tmp <= par_IN;
                when "01" =>                           -- Serielles Laden Shift Right
                    tmp(2 downto 0) <= tmp(3 downto 1);
                    tmp(3) <= ser_IN;
                when "10" =>                           -- Serielles Laden Shift Left
                    tmp(3 downto 1) <= tmp(2 downto 0);
                    tmp(0) <= ser_IN;
                when others =>								 
                    tmp <= tmp;
            end case;
        END IF;
    END PROCESS;
	 
	 par_OUT <= tmp;

END behavior;