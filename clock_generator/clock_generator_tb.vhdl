library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity clock_generator_tb is
end clock_generator_tb;

architecture behav of clock_generator_tb is
	component clock_generator
		port(
            skip_control: in std_logic_vector(1 downto 0); -- 00=no skip, 01=skip 1, 10=skip 2, 11 never happens
            alu_result_is_zero: in std_logic;
            input_clk: in std_logic;
            output_clk: out std_logic
        );
	end component;
	signal sc: std_logic_vector(1 downto 0); --skip control
	signal ariz, i_clk, o_clk: std_logic; --ALU result is zero, input clock, output clock
begin
	cg: clock_generator port map(
	    skip_control => sc,
	    alu_result_is_zero => ariz,
	    input_clk => i_clk,
	    output_clk => o_clk
	);
    
    i_clk <= '0','1' after 1 ns, 
             '0' after 2 ns, '1' after 3 ns, 
             '0' after 4 ns, '1' after 5 ns, 
             '0' after 6 ns, '1' after 7 ns,
             '0' after 8 ns, '1' after 9 ns,
             '0' after 10 ns, '1' after 11 ns,
             '0' after 12 ns, '1' after 13 ns,
             '0' after 14 ns, '1' after 15 ns,
             '0' after 16 ns, '1' after 17 ns;
    
    testprocess: process is begin
		--Test the "no skip" action, with non-zero for the ALU result (ariz=0)
		sc <= "00";
		ariz <= '0';
		wait for 1.5 ns;
		assert o_clk = i_clk report "bad output value (no skip, non-zero)" severity error;
		
		--Test the "no skip" action, with zero for the ALU result (ariz=1)
		sc <= "00";
		ariz <= '1';
		wait for 1 ns;
		assert o_clk = i_clk report "bad output value (no skip, zero)" severity error;
		
		--Test the "skip 1" action, with non-zero for the ALU result (ariz=0)
		sc <= "01";
		ariz <= '0';
		wait for 1 ns;
		assert o_clk = i_clk report "bad output value (skip 1, non-zero, 1)" severity error;
		wait for 1 ns;
		assert o_clk = i_clk report "bad output value (skip 1, non-zero, 2)" severity error;
		
		--Test the "skip 1" action, with zero for the ALU result (ariz=1)
		sc <= "01";
		ariz <= '1';
		wait for 1 ns;
		assert o_clk = '0' report "bad output value (skip 1, zero, 1)" severity error;
		wait for 1 ns;
		assert o_clk = i_clk report "bad output value (skip 1, zero, 2)" severity error;
		
		--Test the "skip 2" action, with non-zero for the ALU result (ariz=0)
		sc <= "10";
		ariz <= '0';
		wait for 1 ns;
		assert o_clk = i_clk report "bad output value (skip 2, non-zero, 1)" severity error;
		wait for 1 ns;
		assert o_clk = i_clk report "bad output value (skip 2, non-zero, 2)" severity error;
		wait for 1 ns;
		assert o_clk = i_clk report "bad output value (skip 2, non-zero, 3)" severity error;
		
		--Test the "skip 2" action, with zero for the ALU result (ariz=1)
		sc <= "10";
		ariz <= '1';
		wait for 1 ns;
		assert o_clk = '0' report "bad output value (skip 2, zero, 1)" severity error;
		wait for 1 ns;
		assert o_clk = '0' report "bad output value (skip 2, zero, 2)" severity error;
		wait for 1 ns;
		assert o_clk = i_clk report "bad output value (skip 2, zero, 3)" severity error;
		
		--Wait forever. This will finish the simulation.
		wait;
    end process testprocess;
end behav;