------------------------------------------------
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
------------------------------------------------

-- Pinbelegung:

--clk				Input		PIN_Y2
--data_in[3]	Input		PIN_AD27		- SW0
--data_in[2]	Input		PIN_AC27		- SW1
--data_in[1]	Input		PIN_AC28		- SW2
--data_in[0]	Input		PIN_AB28		- SW3
--e				Output	PIN_L4
--lcd_data[7]	Output	PIN_M5	
--lcd_data[6]	Output	PIN_M3
--lcd_data[5]	Output	PIN_K2
--lcd_data[4]	Output	PIN_K1
--lcd_data[3]	Output	PIN_K7
--lcd_data[2]	Output	PIN_L2
--lcd_data[1]	Output	PIN_L1
--lcd_data[0]	Output	PIN_L3
--rs				Output	PIN_M2
--rw				Output	PIN_M1

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Ueb3_1 IS
  PORT(
      clk       : IN  STD_LOGIC;  							--system clock
		data_in 	 : IN STD_LOGIC_VECTOR(3 downto 0);
      rw, rs, e : OUT STD_LOGIC;  							--read/write, setup/data, and enable for lcd
      lcd_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		segments	 : OUT STD_LOGIC_VECTOR(6 downto 0)); 	--data signals for lcd
END Ueb3_1;

ARCHITECTURE behavior OF Ueb3_1 IS
  SIGNAL   lcd_enable : STD_LOGIC;
  SIGNAL   lcd_bus    : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL   lcd_busy   : STD_LOGIC;
  SIGNAL   gray_sig, aiken_sig, bcd_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
  COMPONENT lcd_controller IS
    PORT(
       clk        : IN  STD_LOGIC; --system clock
       reset_n    : IN  STD_LOGIC; --active low reinitializes lcd
       lcd_enable : IN  STD_LOGIC; --latches data into lcd controller
       lcd_bus    : IN  STD_LOGIC_VECTOR(9 DOWNTO 0); --data and control signals
       busy       : OUT STD_LOGIC; --lcd controller busy/idle feedback
       rw, rs, e  : OUT STD_LOGIC; --read/write, setup/data, and enable for lcd
       lcd_data   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); --data signals for lcd
  END COMPONENT;
  
  COMPONENT sevenSeg IS
		PORT(num : IN STD_LOGIC_VECTOR(3 downto 0);
			segments: out std_LOGIC_VECTOR(6 downto 0));
	END COMPONENT;
BEGIN

  --instantiate the lcd controller
  dut: lcd_controller
    PORT MAP(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, 
             busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
				 
	rand: sevenSeg	
	 PORT MAP(num => data_in, segments => segments);
  
  PROCESS(clk)
    VARIABLE char  :  INTEGER RANGE 0 TO 32 := 0;
  BEGIN
    IF(clk'EVENT AND clk = '1') THEN
      IF(lcd_busy = '0' AND lcd_enable = '0') THEN
        lcd_enable <= '1';
        IF(char < 32) THEN
          char := char + 1;
		  else
			 char := 0;
        END IF;
		  
        CASE char IS
          when 1 => lcd_bus <= "1001000001";   -- A ab hier Data fuer obere Zeile
          when 2 => lcd_bus <= "1001001001";   -- I
          when 3 => lcd_bus <= "1001001011";   -- K
          when 4 => lcd_bus <= "1001000101";   -- E
          when 5 => lcd_bus <= "1001001110";   -- N
          when 6 => lcd_bus <= "1011111110";   -- ' '
          when 7 => lcd_bus <= "1001000111";   -- G
          when 8 => lcd_bus <= "1001010010";   -- R
          when 9 => lcd_bus <= "1001000001";   -- A
          when 10 => lcd_bus <= "1001011001";   -- Y
          when 11 => lcd_bus <= "1011111110";   -- ' '
          when 12 => lcd_bus <= "1001000010";   -- B
          when 13 => lcd_bus <= "1001000011";   -- C
          when 14 => lcd_bus <= "1001000100";   -- D
          when 15 => lcd_bus <= "0011000000";   -- Sprung in die naechste Zeile
			 when 16 => if (aiken_sig(3) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 17 => if (aiken_sig(2) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 18 => if (aiken_sig(1) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 19 => if (aiken_sig(0) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 20 => lcd_bus <= "1011111110"; 
			 when 21 => lcd_bus <= "1011111110"; 
			 when 22 => if (gray_sig(3) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 23 => if (gray_sig(2) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 24 => if (gray_sig(1) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 25 => if (gray_sig(0) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 26 => lcd_bus <= "1011111110"; 
			 when 27 => if (bcd_sig(3) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 28 => if (bcd_sig(2) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 29 => if (bcd_sig(1) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 30 => if (bcd_sig(0) = '1') then lcd_bus <= "1000110001"; else lcd_bus <= "1000110000"; end if;
			 when 31 => lcd_bus <= "0000000010";   -- Sprung an Anfang
          WHEN OTHERS => lcd_enable <= '0';
        END CASE;
      ELSE
        lcd_enable <= '0';
      END IF;
    END IF;
  END PROCESS;
  
  process (data_in)
    begin
	   case(data_in) is
            when "0000" => bcd_sig <= "0000"; aiken_sig <= "0000"; gray_sig <= "0000";
				when "0001" => bcd_sig <= "0001"; aiken_sig <= "0001"; gray_sig <= "0001";
				when "0010" => bcd_sig <= "0010"; aiken_sig <= "0010"; gray_sig <= "0011";
				when "0011" => bcd_sig <= "0011"; aiken_sig <= "0011"; gray_sig <= "0010";
				when "0100" => bcd_sig <= "0100"; aiken_sig <= "0100"; gray_sig <= "0110";
				when "0101" => bcd_sig <= "0101"; aiken_sig <= "1011"; gray_sig <= "0111";
				when "0110" => bcd_sig <= "0110"; aiken_sig <= "1100"; gray_sig <= "0101";
				when "0111" => bcd_sig <= "0111"; aiken_sig <= "1101"; gray_sig <= "0100";
				when "1000" => bcd_sig <= "1000"; aiken_sig <= "1110"; gray_sig <= "1100";
				when "1001" => bcd_sig <= "1001"; aiken_sig <= "1111"; gray_sig <= "1101";
            when others => bcd_sig <= "0000"; aiken_sig <= "0000"; gray_sig <= "0000";
        end case ;
  end process;
	   
 
END behavior;
