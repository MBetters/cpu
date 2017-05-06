library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity sign_extender_tb is
end sign_extender_tb;

architecture behav of sign_extender_tb is
	component sign_extender
		port(
            i: in std_logic_vector(3 downto 0); -- input
            o: out std_logic_vector(7 downto 0) -- output
        );
	end component;
	signal i_sig: std_logic_vector(3 downto 0);
	signal o_sig: std_logic_vector(7 downto 0);
begin
	se: sign_extender port map(
	    i => i_sig,
	    o => o_sig
	);
    
    testprocess: process is begin
		--Test zeroes extension
		i_sig <= "0101";
		wait for 1 ns;
		assert o_sig = "00000101" report "bad output value" severity error;
		--Test ones extension
		i_sig <= "1010";
		wait for 1 ns;
		assert o_sig = "11111010" report "bad output value" severity error;
		--Wait forever. This will finish the simulation.
		wait;
    end process testprocess;
end behav;