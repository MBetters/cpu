library ieee;
use ieee.std_logic_1164.all;

entity clock_generator is
    port(
        skip_control: in std_logic_vector(1 downto 0); -- 00=no skip, 01=skip 1, 10=skip 2, 11 never happens
        alu_result_is_zero: in std_logic;
        input_clk: in std_logic;
        output_clk: out std_logic
    );
end clock_generator;

architecture behav of clock_generator is
    signal branch_control: std_logic_vector(1 downto 0);
    signal skip_reg_next_value_sel: std_logic_vector(1 downto 0);
    signal skip_reg_next_value: std_logic_vector(1 downto 0);
    signal skip_reg_current_value: std_logic_vector(1 downto 0);
    signal skip_reg_current_value_is_non_zero: std_logic;
    signal clock_control: std_logic;
    signal skip_reg_current_value_decremented: std_logic_vector(1 downto 0);
    component two_bit_reg
        port(
            i: in std_logic_vector(1 downto 0); -- input data
		    clk: in std_logic; -- clock
		    sel: in std_logic; -- operation selection (0 = hold, 1 = load)
		    o: out std_logic_vector(1 downto 0) -- output data
	    );
    end component;
begin
    branch_control <= skip_control when alu_result_is_zero = '1' else
                      "00";
    skip_reg_current_value_is_non_zero <= skip_reg_current_value(1) or skip_reg_current_value(0);
    skip_reg_next_value_sel <= branch_control when skip_reg_current_value_is_non_zero = '0' else 
                               "00";
    
    skip_reg_current_value_decremented <= "10" when skip_reg_current_value = "11" else
                                          "01" when skip_reg_current_value = "10" else
                                          "00";
    skip_reg_next_value <= skip_reg_current_value_decremented when skip_reg_next_value_sel = "00" else 
                           skip_reg_next_value_sel;
    
    skip_reg: two_bit_reg port map(
        i => skip_reg_next_value,
        clk => input_clk,
        sel => '1',
        o => skip_reg_current_value
    );
    
    clock_control <= skip_reg_current_value_is_non_zero;
    output_clk <= input_clk when clock_control = '0' else
                  '0';
end behav;