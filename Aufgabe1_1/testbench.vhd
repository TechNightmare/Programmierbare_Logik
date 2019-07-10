--------------------------
-- Abgabe Ubueng 4.1.1
-- Gruppe: Frank Ehlert, Dawid Kohl, Paul Wagner
-- Testbench für einfaches Register
--------------------------
library ieee; 
use ieee.std_logic_1164.all; 


entity tb_simple_register is 
end tb_simple_register; 

architecture testbench of tb_simple_register is 

	component simple_register
		port ( 	LD, CLR, CLK, D 	: in std_logic; 
					Q 						: out std_logic); 
	end component; 

	signal CLK, CLR, D, Q, LD : std_logic := '0';
	
	begin
		
		dut: simple_register
		port map ( 	CLK 	=> CLK, 
						CLR 	=> CLR, 
						Q 		=> Q,
						D 		=> D,
						LD 	=> LD);
		
	CLK <= Not CLK after 2.5 ns;
	CLR <= '0' after 5 ns, '0' after 10 ns, '0' after 15 ns, '0' after 20 ns, '0' after 25 ns, '0' after 30 ns, '1' after 35 ns, '1' after 40 ns;
	LD  <= '0' after 5 ns, '0' after 10 ns, '1' after 15 ns, '1' after 20 ns, '0' after 25 ns, '0' after 30 ns, '1' after 35 ns, '1' after 40 ns;
	D   <= '0' after 5 ns, '1' after 10 ns, '0' after 15 ns, '1' after 20 ns, '0' after 25 ns, '1' after 30 ns, '0' after 35 ns, '1' after 40 ns;

end testbench;