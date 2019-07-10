------------------------------------------------
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
------------------------------------------------

--m[3]	Input		PIN_AB26			Switch 7 - Switch 4
--m[2]	Input		PIN_AD26
--m[1]	Input		PIN_AC26
--m[0]	Input		PIN_AB27

--p[3]	Input		PIN_AD27			Switch 3 - Switch 0
--p[2]	Input		PIN_AC27
--p[1]	Input		PIN_AC28
--p[0]	Input		PIN_AB28

--O[7]	Output	PIN_H19			LED 7 - LED 0
--O[6]	Output	PIN_J19
--O[5]	Output	PIN_E18
--O[4]	Output	PIN_F18
--O[3]	Output	PIN_F21
--O[2]	Output	PIN_E19
--O[1]	Output	PIN_F19
--O[0]	Output	PIN_G19



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

   
entity Ueb4 is
    port(m, p: in std_logic_vector(3 downto 0);			--m entspricht Multiplikator , p entspricht Multiplikand
            O: out std_logic_vector(7 downto 0));
end Ueb4;
   
architecture behavior of Ueb4 is
 begin
           
process(m, p)
             variable a: std_logic_vector(3 downto 0);				--Akku
				 variable q: std_logic_vector(4 downto 0);				
				 variable atemp : std_logic_vector(3 downto 0);			--fuer das Bit-Shiften Zwischenspeicher	
				 variable complement: std_logic_vector(3 downto 0);   --2er Komplement des Multiplikators
				
				 begin
						  if(p = "0000" OR m = "0000") then					--wenn ein Faktor 0 ist ist die Ausgabe 0
								O <= "00000000";
								
						  else	
							  a := "0000";
							  complement := NOT(m) + 1;
							  q(4 downto 1) := p;
							  q(0) := '0';
																			
							  for i in 0 to 3 loop
								  if (q(1) = '1' and q(0) = '0') then
									  a := a + complement;
									 
							  elsif(q(1) = '0' and q(0) = '1') then
									  a := a + m;
									 
							  end if;
							  --Shiften
								  atemp := a;					--fuer schiebe operationen zwischenspeichern
								  q(0) := q(1);
								  a(3) := q(1);
								  a(2 downto 0) := atemp(3 downto 1);
								  q(3 downto 1) := q(4 downto 2);
								  q(4)			 := atemp(0);
								 
							  end loop;
							 
							  O(7 downto 4) <= a(3 downto 0);
							  O(3 downto 0) <= q(4 downto 1);		--Zuweisung Output
                   end if;
				end process;
end behavior;
