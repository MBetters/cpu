library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use STD.textio.all;

entity cpu_tb is
end cpu_tb;

architecture behav of cpu_tb is
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
	signal i: std_logic_vector(1 downto 0); --instruction
	signal clk: std_logic; --clock
	signal d0, d1, d2, d3: std_logic_vector(3 downto 0);
	file instructions_file: text; --file with 8-bit instructions on each line
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
    
    --Testing with VHDL File I/O
    testprocess: process is 
        variable instruction_line: line;
        variable instruction_str: std_logic_vector(7 downto 0);
        variable newline_char: character;
        variable d0_char: character;
        variable d1_char: character;
        variable d2_char: character;
        variable d3_char: character;
    begin
    	assert false report "CPU Testbench" severity note;
    	assert false report "$$$$$$$$$$$$$$$$$$$$$$$$$" severity note;
		file_open(instructions_file, "instructions1.txt",  read_mode);
		while not endfile(instructions_file) loop
			--Read a line from the instructions file
	    	readline(instructions_file, instruction_line);
	    	--Read an instruction string (8 '0'/'1' chars) to the instruction string variable
	    	read(instruction_line, instruction_str);
	    	--Read a newline character to the newline character variable (and do nothing with it)
	    	read(instruction_line, newline_char);
	    	
	    	--Pass the instruction string to a signal, to allow the CPU to use it.
	    	i <= instruction_str;
	 
			--Wait for the CPU to do the instruction,
			--which will drive the display signals if the instruction is a print
	    	wait for 100 ns;
	 
			assert false report "CPU Printer Output:" severity note;
			
			if (to_integer(unsigned(d0)) = 15) then --15 = "1111"
				d0_char = ' ';
			elsif (to_integer(unsigned(d0)) = 14) then  --14 = "1110"
				d0_char = '-';
			else
				d0_char = character(to_integer(unsigned(d0)));
			end if;
			
			if (to_integer(unsigned(d1)) = 15) then --15 = "1111"
				d1_char = ' ';
			elsif (to_integer(unsigned(d1)) = 14) then  --14 = "1110"
				d1_char = '-';
			else
				d1_char = character(to_integer(unsigned(d1)));
			end if;
			
			if (to_integer(unsigned(d2)) = 15) then --15 = "1111"
				d2_char = ' ';
			elsif (to_integer(unsigned(d2)) = 14) then  --14 = "1110"
				d2_char = '-';
			else
				d2_char = character(to_integer(unsigned(d2)));
			end if;
			
			if (to_integer(unsigned(d3)) = 15) then --15 = "1111"
				d3_char = ' ';
			elsif (to_integer(unsigned(d3)) = 14) then  --14 = "1110"
				d3_char = '-';
			else
				d3_char = character(to_integer(unsigned(d3)));
			end if;
			
	    	assert false report d0_char&d1_char&d2_char&d3_char severity note;
	    	assert false report "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%" severity note;
	    end loop;
	 
		--Close the instructions file
	    file_close(instructions_file);
	    
		--Wait forever. This will finish the simulation.
		wait;
    end process testprocess;
    
end behav;