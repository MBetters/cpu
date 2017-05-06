library ieee;
use ieee.std_logic_1164.all;

use work.all;
 
entity instruction_decoder_tb is
end entity instruction_decoder_tb;

architecture dataflow of instruction_decoder_tb is
    --Component(s)
    component instruction_decoder
        port(
        instruction : in std_logic_vector(7 downto 0);
        print_control : out std_logic;
        operation_select : out std_logic;
        write_address : out std_logic_vector(1 downto 0);
        write_enable : out std_logic;
        reg1 : out std_logic_vector(1 downto 0);
        reg2 : out std_logic_vector(1 downto 0);
        write_data_select : out std_logic;
        immediate : out std_logic_vector(3 downto 0);
        skip_control : out std_logic_vector(1 downto 0)
    );
    end component;
    --Signal(s)
    signal inst : std_logic_vector(7 downto 0);
    signal pr_con, op_sel, we, wd_sel : std_logic;
    signal wa, register1, register2, sc : std_logic_vector(1 downto 0);
    signal imm : std_logic_vector(3 downto 0);
begin
    
    instruction_decoder_instance : instruction_decoder 
        port map(instruction=>inst,
        print_control=>pr_con,
        operation_select=>op_sel,
        write_address=>wa,
        write_enable=>we,
        reg1=>register1,
        reg2=>register2,
        write_data_select=>wd_sel,
        immediate=>imm,
        skip_control=>sc);
    testprocess: process is begin
        --Basic test
        inst<="00000000";
        wait for 10 ns;
		assert pr_con = '0' report "Wrong Print Control" severity error;
		assert wa = "00" report "Wrong Write Address" severity error;
		assert we = '1' report "Wrong Write Enable" severity error;
		assert wd_sel = '0' report "Wrong Write Data Select" severity error;
		assert sc = "00" report "Wrong Skip Control" severity error;
		assert imm = "0000" report "Wrong Immediate" severity error;
		
		--Loaid 0011 into register 10
		inst<="00100011";
        wait for 10 ns;
		assert pr_con = '0' report "Wrong Print Control" severity error;
		assert wa = "10" report "Wrong Write Address" severity error;
		assert we = '1' report "Wrong Write Enable" severity error;
		assert wd_sel = '0' report "Wrong Write Data Select" severity error;
		assert sc = "00" report "Wrong Skip Control" severity error;
		assert imm = "0011" report "Wrong Immediate" severity error;
		
		--Add Registers 10 and 00
		inst<="01100011";
        wait for 10 ns;
		assert pr_con = '0' report "Wrong Print Control" severity error;
		assert op_sel = '0' report "Wrong Operation Select" severity error;
		assert wa = "11" report "Wrong Write Address" severity error;
		assert we = '1' report "Wrong Write Enable" severity error;
		assert wd_sel = '1' report "Wrong Write Data Select" severity error;
		assert sc = "00" report "Wrong Skip Control" severity error;
-- 		assert imm = "0011" report "Wrong Immediate" severity error;
		assert register2 = "00" report "Wrong Register 2 Address" severity error;
		assert register1 = "10" report "Wrong Register 1 Address" severity error;
		
		--Subtract Registers 10 and 00
		inst<="10100011";
        wait for 10 ns;
		assert pr_con = '0' report "Wrong Print Control" severity error;
		assert op_sel = '1' report "Wrong Operation Select" severity error;
		assert wa = "11" report "Wrong Write Address" severity error;
		assert we = '1' report "Wrong Write Enable" severity error;
		assert wd_sel = '1' report "Wrong Write Data Select" severity error;
		assert sc = "00" report "Wrong Skip Control" severity error;
-- 		assert imm = "0011" report "Wrong Immediate" severity error;
		assert register2 = "00" report "Wrong Register 2 Address" severity error;
		assert register1 = "10" report "Wrong Register 1 Address" severity error;
		
		--Print Addr 00
		inst<="11000011";
        wait for 10 ns;
		assert pr_con = '1' report "Wrong Print Control" severity error;
-- 		assert op_sel = '1' report "Wrong Operation Select" severity error;
-- 		assert wa = "11" report "Wrong Write Address" severity error;
		assert we = '0' report "Wrong Write Enable" severity error;
-- 		assert wd_sel = '1' report "Wrong Write Data Select" severity error;
		assert sc = "00" report "Wrong Skip Control" severity error;
-- 		assert imm = "0011" report "Wrong Immediate" severity error;
-- 		assert register2 = "00" report "Wrong Register 2 Address" severity error;
		assert register1 = "00" report "Wrong Register 1 Address" severity error;
		
		--Skip 2 inst
		inst<="11100011";
        wait for 10 ns;
		assert pr_con = '0' report "Wrong Print Control" severity error;
		assert op_sel = '1' report "Wrong Operation Select" severity error;
-- 		assert wa = "11" report "Wrong Write Address" severity error;
		assert we = '0' report "Wrong Write Enable" severity error;
-- 		assert wd_sel = '1' report "Wrong Write Data Select" severity error;
		assert sc = "10" report "Wrong Skip Control" severity error;
-- 		assert imm = "0011" report "Wrong Immediate" severity error;
		assert register2 = "01" report "Wrong Register 2 Address" severity error;
		assert register1 = "00" report "Wrong Register 1 Address" severity error;
		
		--Skip 1 inst
		inst<="11100010";
        wait for 10 ns;
		assert pr_con = '0' report "Wrong Print Control" severity error;
		assert op_sel = '1' report "Wrong Operation Select" severity error;
-- 		assert wa = "11" report "Wrong Write Address" severity error;
		assert we = '0' report "Wrong Write Enable" severity error;
-- 		assert wd_sel = '1' report "Wrong Write Data Select" severity error;
		assert sc = "01" report "Wrong Skip Control" severity error;
-- 		assert imm = "0011" report "Wrong Immediate" severity error;
		assert register2 = "01" report "Wrong Register 2 Address" severity error;
		assert register1 = "00" report "Wrong Register 1 Address" severity error;
		assert false report "end of test" severity note;
		
		
		--  Wait forever; this will finish the simulation.
		wait;
    end process testprocess;
    
end architecture dataflow;