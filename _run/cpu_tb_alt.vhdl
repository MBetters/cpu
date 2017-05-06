library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

library std;
use std.textio.all;

entity cpu_tb_alt is
end cpu_tb_alt;

architecture behav of cpu_tb_alt is
	component cpu
		port (
            instruction: in std_logic_vector(7 downto 0);
            clock: in std_logic;
            disp_0: out std_logic_vector(3 downto 0);
        	disp_1: out std_logic_vector(3 downto 0);
        	disp_2: out std_logic_vector(3 downto 0);
        	disp_3: out std_logic_vector(3 downto 0)
        );
	end component;
	type instructions_arr is array (0 to 8) of std_logic_vector(7 downto 0);
				--CHANGE THIS MAX INDEX^^^^ DEPENDING ON THE LENGTH OF THE instruction_instance CONSTANT
	constant instruction_instance : instructions_arr:=("00000101", "00010101", "00100001", "00110001", "11100011", "00100000", "00110000", "11010000", "11011000");
			--^^^^^^^^^^^^^^^^^^^CHANGE THE instruction_instance ARRAY FOR EACH BENCHMARK
	signal i: std_logic_vector(7 downto 0); --instruction
	signal clk: std_logic := '0'; --clock
	signal d0, d1, d2, d3: std_logic_vector(3 downto 0);
begin
	
	--Instantiate a CPU
	c: cpu port map(
	    instruction => i,
	    clock => clk,
	    disp_0 => d0,
        disp_1 => d1,
        disp_2 => d2,
        disp_3 => d3
	);
	
	clk <= not (clk) after 5 ns; --clock with time period 10 ns
	
	--read process
	reading: process is
	    variable instruction_vec: std_logic_vector(7 downto 0);
	    variable index : integer := 0;
	    variable d0_char: character;
        variable d1_char: character;
        variable d2_char: character;
        variable d3_char: character;
	begin
		wait until clk = '1' and clk'event;
		if index >= instruction_instance'high + 1 then
		    assert false report "End of test" severity note;
		    assert false report "simulation ended" severity failure;
		else
		    i <= instruction_instance(index);
		    
		    wait for 1 ns;
		    
		    -- assert false report "Instruction: "&integer'image(to_integer(unsigned(i))) severity note;
		    -- assert false report "Digit 0: "&integer'image(to_integer(unsigned(d0))) severity note;
		    -- assert false report "Digit 1: "&integer'image(to_integer(unsigned(d1))) severity note;
		    -- assert false report "Digit 2: "&integer'image(to_integer(unsigned(d2))) severity note;
		    -- assert false report "Digit 3: "&integer'image(to_integer(unsigned(d3))) severity note;
		    assert false report "CPU Printer Output:" severity note;
			
			if (to_integer(unsigned(d0)) = 15) then --15 = "1111"
				d0_char := ' ';
			elsif (to_integer(unsigned(d0)) = 14) then  --14 = "1110"
				d0_char := '-';
			else
				--assert false report "CANDY" severity note;
				--assert false report integer'image(to_integer(unsigned(d0))) severity note;
				d0_char := character'val(to_integer(unsigned(d0)) + 48);
			end if;
			
			if (to_integer(unsigned(d1)) = 15) then --15 = "1111"
				d1_char := ' ';
			elsif (to_integer(unsigned(d1)) = 14) then  --14 = "1110"
				d1_char := '-';
			else
				d1_char := character'val(to_integer(unsigned(d1)) + 48);
			end if;
			
			if (to_integer(unsigned(d2)) = 15) then --15 = "1111"
				d2_char := ' ';
			elsif (to_integer(unsigned(d2)) = 14) then  --14 = "1110"
				d2_char := '-';
			else
				d2_char := character'val(to_integer(unsigned(d2)) + 48);
			end if;
			
			if (to_integer(unsigned(d3)) = 15) then --15 = "1111"
				d3_char := ' ';
			elsif (to_integer(unsigned(d3)) = 14) then  --14 = "1110"
				d3_char := '-';
			else
				d3_char := character'val(to_integer(unsigned(d3)) + 48);
			end if;
			
	    	assert false report d3_char&d2_char&d1_char&d0_char severity note;
	    	assert false report "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" severity note;
			index := index + 1;
		end if;
	end process reading;
    
    
end behav;