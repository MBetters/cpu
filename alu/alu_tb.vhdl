library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

--A testbench has no ports.
entity alu_tb is
end;

architecture behav of alu_tb is
	--Declaration of the component that will be instantiated.
	component alu
		port(
	        data1, data2: in std_logic_vector(7 downto 0);
	        op : in std_logic;
	        result : out std_logic_vector(7 downto 0)
    	);
	end component;
	--  Specifies which entity is bound with the component.
	-- for shift_reg_0: shift_reg use entity work.shift_reg(rtl);
	signal arg1, arg2, output : std_logic_vector(7 downto 0);
	signal over, under, operation : std_logic;
begin
	--  Component instantiation.
	my_alu: alu port map (data1 => arg1,
                          data2 => arg2, 
                          op=>operation,
                          result=>output);
	--  This process does the real job.
    operation <= '0', '1' after 9 ns, '0' after 14 ns, '1' after 24 ns, '0' after 31 ns;
    arg1 <= "00000100", "11111000" after 14 ns; -- 4 then -8
    arg2 <= "00000001", "00000111" after 4 ns, "00000001" after 9 ns, "11111000" after 19 ns, "11111000" after 24 ns, "00000111" after 29 ns, "11111010" after 34 ns;
    testprocess: process is begin
        --Test ADD
        wait for 1 ns;
		assert output = "00000101" report "bad output value" severity error;
		assert false report integer'image(to_integer(unsigned(output))) severity note;
		
		wait for 4 ns;--5ns
		assert output = "00001011" report "bad output value" severity error;
		assert false report integer'image(to_integer(unsigned(output))) severity note;
		
		wait for 5 ns;--10ns
		assert output = "00000011" report "bad output value" severity error;
		assert false report integer'image(to_integer(unsigned(output))) severity note;
		
		wait for 5 ns;--15ns
		assert output = "11111001" report "bad output value" severity error;
		assert false report integer'image(to_integer(unsigned(output))) severity note;
		
		wait for 5 ns;--20ns
		assert output = "11110000" report "bad output value" severity error;
		assert false report integer'image(to_integer(unsigned(output))) severity note;
		
		wait for 5 ns;--25ns
		assert output = "00000000" report "bad output value" severity error;
		assert false report integer'image(to_integer(unsigned(output))) severity note;
		
		wait for 5 ns;--30ns
		assert output = "11110001" report "bad output value" severity error;
		
		wait for 5 ns;--35ns
		assert output = "11110010" report "bad output value" severity error;
		
		assert false report integer'image(to_integer(unsigned(output))) severity note;
		--  Wait forever; this will finish the simulation.
		wait;
		
    end process testprocess;
end behav;
