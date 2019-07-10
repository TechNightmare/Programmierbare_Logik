library ieee;
use ieee.std_logic_1164.all;

entity tb_calc is
end tb_calc;

architecture testbench of tb_calc is
component calc is
    port(CLK, RST, CARRY, SEL: in std_logic;
        in_vecX: in std_logic_vector(3 downto 0);
        in_vecY: in std_logic_vector(3 downto 0);
        out_vec: out std_logic_vector(3 downto 0));
end component;

signal CLK: std_logic := '0';
signal RST: std_logic := '0';
signal CARRY: std_logic := '0';
signal SEL: std_logic := '1';
signal x: std_logic_vector(3 downto 0) := "1011";
signal y: std_logic_vector(3 downto 0) := "0001";
signal out_vec: std_logic_vector(3 downto 0);

begin
dut: calc
port map(CLK, RST, CARRY, SEL, x, y, out_vec);

CLK <= '1' after 5 ns, '0' after 10 ns, '1' after 15 ns, '0' after 20 ns, '1' after 25 ns, '0' after 30 ns, '1' after 35 ns, '0' after 40 ns;

end testbench;
