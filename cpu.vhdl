library ieee;
use ieee.std_logic_1164.all;

-- A single-cycle CPU
entity cpu is
    port (
        instruction: in std_logic_vector(7 downto 0);
        clock: in std_logic;
        disp_0: out std_logic_vector(3 downto 0);
        disp_1: out std_logic_vector(3 downto 0);
        disp_2: out std_logic_vector(3 downto 0);
        disp_3: out std_logic_vector(3 downto 0)
    );
end cpu;

architecture struc of cpu is

    component instruction_decoder
        port(
            instruction: in std_logic_vector(7 downto 0);
            print_control: out std_logic;
            operation_select: out std_logic;
            write_address: out std_logic_vector(1 downto 0);
            write_enable: out std_logic;
            reg1: out std_logic_vector(1 downto 0);
            reg2: out std_logic_vector(1 downto 0);
            write_data_select: out std_logic;
            immediate: out std_logic_vector(3 downto 0);
            skip_control: out std_logic_vector(1 downto 0)
        );
    end component;
    
    signal print_control: std_logic;
    signal operation_select: std_logic;
    signal write_address: std_logic_vector(1 downto 0);
    signal write_enable: std_logic;
    signal reg1: std_logic_vector(1 downto 0);
    signal reg2: std_logic_vector(1 downto 0);
    signal write_data_select: std_logic;
    signal immediate: std_logic_vector(3 downto 0);
    signal skip_control: std_logic_vector(1 downto 0);
    
    component sign_extender
        port(
            i: in std_logic_vector(3 downto 0); -- input
            o: out std_logic_vector(7 downto 0) -- output
        );
    end component;
    
    signal extended_immediate: std_logic_vector(7 downto 0);
    
    signal write_data: std_logic_vector(7 downto 0);
    
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
    
    signal data1, data2: std_logic_vector(7 downto 0);
    
    component alu
        port(
            data1, data2: in std_logic_vector(7 downto 0);
            op: in std_logic;
            result: out std_logic_vector(7 downto 0)
        );
    end component;
    
    signal alu_result: std_logic_vector(7 downto 0);
    signal alu_result_is_zero: std_logic;
    
    component printer
        port(
            i: in std_logic_vector(7 downto 0);
            print_control: in std_logic;
            disp_0: out std_logic_vector(3 downto 0);
            disp_1: out std_logic_vector(3 downto 0);
            disp_2: out std_logic_vector(3 downto 0);
            disp_3: out std_logic_vector(3 downto 0)
        );
    end component;
    
    component clock_generator
        port(
            skip_control: in std_logic_vector(1 downto 0); -- 00=no skip, 01=skip 1, 10=skip 2, 11 never happens
            alu_result_is_zero: in std_logic;
            input_clk: in std_logic;
            output_clk: out std_logic
        );
    end component;
    
    signal generated_clock: std_logic;
begin

    id: instruction_decoder port map(
        instruction => instruction,
        print_control => print_control,
        operation_select => operation_select,
        write_address => write_address,
        write_enable => write_enable,
        reg1 => reg1,
        reg2 => reg2,
        write_data_select => write_data_select,
        immediate => immediate,
        skip_control => skip_control
    );
    
    se: sign_extender port map(
        i => immediate,
        o => extended_immediate
    );
    
    write_data <= extended_immediate when write_data_select = '0' else 
                  alu_result;
    
    rf: register_file port map(
        reg1 => reg1,
        reg2 => reg2,
        write_address => write_address,
        write_enable => write_enable,
        write_data => write_data,
        clk => generated_clock,
        data1 => data1,
        data2 => data2
    );
    
    a: alu port map(
        data1 => data1,
        data2 => data2,
        op => operation_select,
        result => alu_result
    );
    
    alu_result_is_zero <= '1' when alu_result = "00000000" else
                          '0';
    
    cg: clock_generator port map(
        skip_control => skip_control,
        alu_result_is_zero => alu_result_is_zero,
        input_clk => clock,
        output_clk => generated_clock
    );
    
    p: printer port map(
        i => data1,
        print_control => print_control,
        disp_0 => disp_0,
        disp_1 => disp_1,
        disp_2 => disp_2,
        disp_3 => disp_3
    );
    
end struc;