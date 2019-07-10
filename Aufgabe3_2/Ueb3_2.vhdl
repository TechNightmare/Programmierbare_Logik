library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Ueb3_2 is
  port (
    num_in                 		: IN std_logic_vector (11 downto 0);      -- Switch Input
    CLK, RST, MODE, State_Btn    : IN std_logic;
	 disp_vector						: OUT std_logic_vector(10 downto 0)
  );
end Ueb3_2;

architecture behave of Ueb3_2 is
  -------- VON AUSSEN --------
  -- 1. und 2. Nibble der Inputzahlen
  signal first_num, second_num : std_logic_vector (7 downto 0);
  -------- INTERNE VERARBEITUNG ---------
  ------ AN KOMPONENTEN -----
  -- Check welche Zahl größer ist
  signal comparator_out : std_logic;
  -- Komplementumwandlung
  signal complement_in, complement_out : std_logic_vector(7 downto 0);
  -- temporäre Signale an Adder
  signal temp_calc_first, temp_calc_second, temp_erg_vector : std_logic_vector(11 downto 0) := (others => '0');
  -- Nibble Check Signale
  signal nibble_to_check, nibble_checked : std_logic_vector(7 downto 0);
  ----- INTERNE -----
  -- Unterscheidung der Rechenoperationen
  signal operation : std_logic_vector (2 downto 0) := (others => '0');
  -- aktueller Zustand
  signal state : std_logic_vector(1 downto 0);
  -- Signale zur Durchfuehrung der Rechenoperationen - zum gegenseitigen Aufrufen der Prozesse
  signal calc_step, required_steps : integer := 0;
  --------- NACH AUSSEN --------
  -- Zahl für display out
  signal display_sig, display_sig_temp1, display_sig_temp2 : std_logic_vector (15 downto 0);
  signal rw, rs, e : STD_LOGIC;  --read/write, setup/data, and enable for lcd
  signal lcd_data  : STD_LOGIC_VECTOR(7 DOWNTO 0);--data signals for lcd

  -- generiert aus 8 Bit Input das Zehnerkomplement
  component complementGenerator is
    port (
      complement_in   : IN  std_logic_vector(7 downto 0);
      complement_out  : OUT std_logic_vector(7 downto 0)
    );
  end component;

  -- Checked 2 Nibble (8 Bit) ob diese noch BCD sind (<=9) - wandelt sonst um
  component nibbleCheck is
    port (
      twoNibble       : IN  std_logic_vector(7 downto 0);
      outTwoNibble    : OUT std_logic_vector(7 downto 0)
    );
  end component;

  -- Volladdierer fuer Rechenoperation
  component twelve_adder is
    port(
      first_num, second_num :   IN  std_logic_vector(11 downto 0);
      erg_vector            :   OUT std_logic_vector(11 downto 0)
    );
  end component;

  -- Display fuer Anzeige und Ausgabe
  component display is
	PORT(
      clk       : IN  STD_LOGIC;  --system clock
      num_sig   : IN STD_LOGIC_VECTOR(15 downto 0);
      state     : IN STD_LOGIC_VECTOR(1 downto 0);
      rw, rs, e : OUT STD_LOGIC;  --read/write, setup/data, and enable for lcd
      lcd_data  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) --data signals for lcd
    );
  end component;
  
  begin
  
  dut1: complementGenerator
    Port Map (complement_in, complement_out);

  dut2: nibbleCheck
    Port Map (nibble_to_check, nibble_checked);

  dut3: twelve_adder
    Port Map (temp_calc_first, temp_calc_second, temp_erg_vector);

  dut4: display
    Port Map (CLK, display_sig, state, rw, rs, e, lcd_data);

  stateSwitch : process(State_Btn, RST)
    begin
      if (RST = '0') then
        state <= "00";
      else
        case state is
          when "00" => state <= "01";
          when "01" => state <= "10";
          when "10" => state <= "11";
          when "11" => state <= "00";
        end case;
      end if;
  end process;

  mainProcess: process (state, num_in, MODE)
    begin
		display_sig_temp1 <= "0000000000000000";
        case (state) is
          when "00" =>  first_num <= num_in(11 downto 4);       -- 1. Zahl einlesen
                        display_sig_temp1(15 downto 12) <= "0000";
                        display_sig_temp1(11 downto  0) <= num_in;
                        if (num_in(3 downto 0) = "1100") then   -- positive 1. Zahl
                          operation(2) <= '1';
                        else                                    -- negative 1. Zahl
                          operation(2) <= '0';
                        end if;
          when "01" =>  second_num <= num_in(11 downto 4);      -- 2. Zahl einlesen
                        display_sig_temp1(15 downto 12) <= "0000";
                        display_sig_temp1(11 downto  0) <= num_in;
                        if (num_in(3 downto 0) = "1100") then   -- positive 2. Zahl
                          operation(0) <= '1';
                        else                                    -- negative 2. Zahl
                          operation(0) <= '0';
                        end if;
          when "10" =>  display_sig_temp1(15 downto 1) <= (others => '0');
                        if (MODE = '1') then            -- Addition
                          operation(1) <= '1';
                          display_sig_temp1(1) <= '1';
                        else                            -- Subtraktion
                          operation(1) <= '0';
                          display_sig_temp1(1) <= '0';
                        end if;
          when "11" =>  required_steps <= 0; -- reset zu Beginn
                        if (operation = "111" OR operation = "100" OR operation = "010" OR operation = "001") then
									required_steps <= 3;
                        elsif (operation = "110" OR operation = "101" OR operation = "011" OR operation = "000") then 
									required_steps <= 5;
                        end if;
        end case;
  end process;

  calcSteps : process (required_steps, temp_erg_vector, nibble_checked, complement_out)
  -- startet das erste Mal wenn mainProcess in Stufe 4 die Stepanzahl setzt
  -- danach startet Prozess immer wenn sich Zwischenergebnis verändert
  begin
    if(calc_step /= required_steps) then      -- setzt Steps hinauf bis alle Schritte abgearbeitet wurden
      calc_step <= calc_step + 1;
    else
      calc_step <= 0;
    end if;

  end process;



  calcProcess : process(calc_step)
    variable erg : std_logic_vector(15 downto 0); -- fuer Umwandlung zu 10er Komplement
    begin
		display_sig_temp2 <= "0000000000000000";
        if (operation = "111" OR operation = "100" OR operation = "010" OR operation = "001") then      -- "normale Addition" also + + +, + - -, - - +, - + -
          case calc_step is
            when 1 =>     -- calcInputs zuweisen
              temp_calc_first(11 downto 8) <= "0000";       -- vier Vorbit anhängen
              temp_calc_first(7 downto 0)  <= first_num;    -- Zahl zuweisen
              temp_calc_second(11 downto 8) <= "0000";
              temp_calc_second(7 downto 0)  <= second_num;
            when 2 =>     -- nibble_to_check durchfuehren
              nibble_to_check <= temp_erg_vector(7 downto 0);
            when 3 =>     -- Displayausgabe zuweisen
				  erg(15 downto 12) := temp_erg_vector(11 downto 8);
              erg (11 downto 4) := nibble_checked;    -- Ergebnis aus checked Nibble an Variable
              if (operation = "010" OR operation = "001") then -- Ergebnis ist negativ (- + - oder - - +)
                erg (3 downto 0) := "1101";
              else
                erg (3 downto 0) := "1100";
              end if;
              display_sig_temp2 <= erg;
				when others => 
				  display_sig_temp2 <= "1010101010101010";
          end case;

        elsif(operation = "110" OR operation = "101" OR operation = "011" OR operation = "000") then   -- Subtraktion also eine von beiden Zahlen ist negativ (+ + -, + - +, - + +, - - -)
          case calc_step is
            when 1 =>  -- fuer Umwandlung in Komplement uebergeben
              if (operation(2) = '0') then      -- wenn 1. Zahl negativ
                complement_in <= first_num;     -- Komplement erzeugen
                if(to_integer(unsigned(first_num)) > to_integer(unsigned(second_num))) then -- negative Zahl größer als positive
                  comparator_out <= '1';
                end if;
              else                              -- wenn 2. Zahl negativ
                complement_in <= second_num;
                if(to_integer(unsigned(second_num)) > to_integer(unsigned(first_num))) then -- negative Zahl größer als positive
                  comparator_out <= '1';
                end if;
              end if;
            when 2 =>   -- Komplement erhalten
              if (operation(2) = '0') then
                temp_calc_first(7 downto 0) <= complement_out;
              else
                temp_calc_second(7 downto 0) <= complement_out;
              end if;
              temp_calc_first(11 downto 8) <= "0000";       -- vier Vorbit anhängen
              temp_calc_second(11 downto 8) <= "0000";
            when 3 =>     -- nibble_to_check durchfuehren
              nibble_to_check <= temp_erg_vector(7 downto 0);
            when 4 =>     -- nochmal Komplement bilden falls negative Zahl größer als Positive
                complement_in <= nibble_checked;
            when 5 =>     -- Displayausgabe zuweisen
              if (comparator_out = '1') then      -- Komplement aus Schritt 4 verwenden
                display_sig_temp2(7 downto 0) <= complement_out;
              else                                -- Komplement direkt von nibble_checked übernehmen
                display_sig_temp2(7 downto 0) <= nibble_checked;
              end if;
				  display_sig_temp2(15 downto 8) <= "00000000";
				when others => 
				  display_sig_temp2 <= "1010101010101010";
          end case;
      end if;
  end process;
  
  process(display_sig_temp1, display_sig_temp2) is
	  begin	
	  if(display_sig_temp1 /= "0000000000000000") then -- vector hat sich veraendert und ist nicht mehr =0
		 display_sig <= display_sig_temp1;
	  else 
		 display_sig <= display_sig_temp2;
		end if;
	end process;
	
	disp_vector(10)<= rw;
	disp_vector(9)<= rs;
	disp_vector(8)<= e;
	disp_vector(7 downto 0)<= lcd_data;

end behave;
