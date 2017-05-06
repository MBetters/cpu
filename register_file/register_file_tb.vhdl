library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity register_file_tb is
end register_file_tb;

architecture behav of register_file_tb is
	component register_file
		port(
            reg1: in std_logic_vector (1 downto 0); -- register address 1
            reg2: in std_logic_vector (1 downto 0); -- register address 2
            write_address: in std_logic_vector(1 downto 0); -- write address
            write_enable: in std_logic; -- write enable
        	write_data: in std_logic_vector(7 downto 0); -- write data
            clk: in std_logic; -- clock
            data1, data2: out std_logic_vector(7 downto 0) -- read data
        );
	end component;
	signal r1, r2, wa: std_logic_vector(1 downto 0);
	signal we, clk: std_logic;
	signal wd, d1, d2: std_logic_vector(7 downto 0);
begin
	rf: register_file port map(
	    reg1 => r1,
	    reg2 => r2,
	    write_address => wa,
	    write_enable => we,
	    write_data => wd,
	    clk => clk,
	    data1 => d1,
	    data2 => d2
	);
    
    clk <= '0','1' after 1 ns, '0' after 10 ns, '1' after 11 ns, '0' after 20 ns, '1' after 21 ns, '0' after 30 ns, '1' after 31 ns,'0' after 40 ns, '1' after 41 ns;
    testprocess: process is begin
        --Test writing to reg00
        we <= '1';
        wa <= "00";
        wd <= "01010101";
        wait for 10 ns;
        --Test writing to reg01
        we <= '1';
        wa <= "01";
        wd <= "10101010";
        wait for 10 ns;
        --Test that writing does not happen when writing is supposed to be disabled
        we <= '0';
        wa <= "01";
        wd <= "11111111";
        wait for 10 ns;
		--Test reading from reg00 and reg01.
		--If this test passes, then so do the previous tests.
		r1 <= "00";
		r2 <= "01";
		wait for 10 ns;
		assert d1 = "01010101" report "bad output value" severity error;
		assert d2 = "10101010" report "bad output value" severity error;
		--Wait forever. This will finish the simulation.
		wait;
    end process testprocess;
end behav;