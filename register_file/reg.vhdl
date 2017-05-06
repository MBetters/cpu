library ieee;
use ieee.std_logic_1164.all;

-- An 8-bit register
entity reg is
	port(
		i: in std_logic_vector(7 downto 0); -- input data
		clk: in std_logic; -- clock
		sel: in std_logic; -- operation selection (0 = hold, 1 = load)
		o: out std_logic_vector(7 downto 0) -- output data
	);
end reg;

architecture behav of reg is
begin
	process(clk) begin
		if rising_edge(clk) then
			if sel = '0' then
				--hold
		    end if;
		    if sel = '1' then
		        --load
		        o <= i;
		    end if;
	    end if;
	end process;
end behav;