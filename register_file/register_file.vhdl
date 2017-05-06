library ieee;
use ieee.std_logic_1164.all;

-- A register file with 4 8-bit registers
entity register_file is
    port(
        reg1: in std_logic_vector (1 downto 0); -- register address 1
        reg2: in std_logic_vector (1 downto 0); -- register address 2
        write_address: in std_logic_vector(1 downto 0); -- write address
        write_enable: in std_logic; -- write enable
    	write_data: in std_logic_vector(7 downto 0); -- write data
        clk: in std_logic; -- clock
        data1, data2: out std_logic_vector(7 downto 0) -- read data
    );
end register_file;

architecture struc of register_file is
    component reg
		port(
		    i: in std_logic_vector(7 downto 0); -- input data
		    clk: in std_logic; -- clock
		    sel: in std_logic; -- operation selection (0 = hold, 1 = load)
		    o: out std_logic_vector(7 downto 0) -- output data
        );
	end component;
	-- Select signals for all 4 registers
	signal sel_vec: std_logic_vector(3 downto 0);
	-- Output signals for each register (flat bus, 4x 8-bit registers --> 32 bits)
	signal o_vec: std_logic_vector(31 downto 0);
begin
    gen: for j in 0 to 3 generate
        reg_j: reg port map(
            i => write_data,
            clk => clk,
            sel => sel_vec(j),
            o => o_vec(j*8 + 7 downto j*8)
        );
    end generate;
    
    sel_vec <= "0001" when write_address = "00" and write_enable = '1' else
               "0010" when write_address = "01" and write_enable = '1' else
               "0100" when write_address = "10" and write_enable = '1' else
               "1000" when write_address = "11" and write_enable = '1' else
               "0000"; --when write_enable = '0'
    
    data1 <= o_vec(7 downto 0) when reg1 = "00" else
             o_vec(15 downto 8) when reg1 = "01" else
             o_vec(23 downto 16) when reg1 = "10" else
             o_vec(31 downto 24); --when reg1 = "11"
          
    data2 <= o_vec(7 downto 0) when reg2 = "00" else
             o_vec(15 downto 8) when reg2 = "01" else
             o_vec(23 downto 16) when reg2 = "10" else
             o_vec(31 downto 24); --when reg2 = "11"
end struc;