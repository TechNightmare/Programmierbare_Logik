--------------------------------------------------------------------------------
--
--   FileName:         lcd_example.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 32-bit Version 11.1 Build 173 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 6/13/2012 Scott Larson
--     Initial Public Release
--
--   Prints "123456789" on a HD44780 compatible 8-bit interface character LCD 
--   module using the lcd_controller.vhd component.
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY display IS
  PORT(
      clk       : IN  STD_LOGIC;  --system clock
      num_sig   : IN STD_LOGIC_VECTOR(15 downto 0);
      state     : IN STD_LOGIC_VECTOR(1 downto 0);
      rw, rs, e : OUT STD_LOGIC;  --read/write, setup/data, and enable for lcd
      lcd_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); --data signals for lcd
END display;

ARCHITECTURE behavior OF display IS
  SIGNAL   lcd_enable : STD_LOGIC;
  SIGNAL   lcd_bus    : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL   lcd_busy   : STD_LOGIC;
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
BEGIN

  --instantiate the lcd controller
  dut: lcd_controller
    PORT MAP(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, 
             busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
  
  PROCESS(clk)
    VARIABLE numOut   : INTEGER RANGE 0 TO 24 := 0;
    VARIABLE position : INTEGER RANGE 0 TO 15 := 15;
    VARIABLE enable   : BOOLEAN := false;
    VARIABLE ergOut   : INTEGER RANGE 0 TO 26 := 0;
    VARIABLE opOut    : INTEGER RANGE 0 TO 9 := 0;
  BEGIN
    IF(clk'EVENT AND clk = '1') THEN
      IF(lcd_busy = '0' AND lcd_enable = '0') THEN
        lcd_enable <= '1';

        --reset for second number(?)
        if(enable = false AND state = "01") then
            numOut := 0;
            position := 0;
            enable := true;
        end if;
        
        if ((state = "00" OR state = "01") AND numOut < 24) then
            case numOut is
              when 0 => lcd_bus <= "1001011010";  -- Z
              when 1 => lcd_bus <= "1001000001";  -- A
              when 2 => lcd_bus <= "1001001000";  -- H
              when 3 => lcd_bus <= "1001001100";  -- L
              when 4 => lcd_bus <= "1000100000";  -- _
              when 5 => if (state = "00") then
                          lcd_bus <= "1000110001";    -- 1
                        else lcd_bus <= "1000110010"; -- 2
                        end if;
              when 6 => lcd_bus <= "0011000000";      -- \n
              when 23 => lcd_bus <= "0000000010";       -- return home
                         position := 15;
              -- Zahl Ausgabe
              when others =>  if (num_sig(position) = '0') then
                                lcd_bus <= "1000110000";
                              else lcd_bus <= "1000110001"; 
                              end if;
                              position := position -1;              
            end case;
            numOut := numOut +1;

        --Ende Zahlen Ausgabe
        elsif (state = "10") then
          -- Operand
          case opOut is
            when 0 => lcd_bus <= "1001001111";  -- O
            when 1 => lcd_bus <= "1001010000";  -- P
            when 2 => lcd_bus <= "1001000101";  -- E
            when 3 => lcd_bus <= "1001010010";  -- R
            when 4 => lcd_bus <= "1001000001";  -- A
            when 5 => lcd_bus <= "1001001110";  -- N
            when 6 => lcd_bus <= "1001000100";  -- D
            when 7 => lcd_bus <= "0011000000"; -- \n
            when 8 => if(num_sig(0) = '1') then
								lcd_bus <= "1000101011";
							 else lcd_bus <= "1000101101";
							 end if; 
            when 9 => lcd_bus <= "0000000010";
          end case;
          opOut := opOut +1;
        elsif (state = "11") then
          --erg
            case ergOut is
              when 0 => lcd_bus <= "1001000101";  -- E
              when 1 => lcd_bus <= "1001010010";  -- R
              when 2 => lcd_bus <= "1001000111";  -- G
              when 3 => lcd_bus <= "1001000101";  -- E
              when 4 => lcd_bus <= "1001000010";  -- B
              when 5 => lcd_bus <= "1001001110";  -- N
              when 6 => lcd_bus <= "1001001001";  -- I
              when 7 => lcd_bus <= "1001000011";  -- S
              when 8 => lcd_bus <= "0011000000";  -- \n
              when 26 => lcd_bus <= "0000000010";       -- return home
                         position := 15;
                         numOut := 0;
                         opOut := 0;
                         ergOut := 0;
              when others =>  if (num_sig(position) = '0') then
                                lcd_bus <= "1000110000";
                              else lcd_bus <= "1000110001"; 
                              end if;
                              position := position -1;              
              end case;
              ergOut := ergOut +1;   
        end if;
      ELSE
        lcd_enable <= '0';
      END IF;
    END IF;
  END PROCESS;
  
END behavior;
