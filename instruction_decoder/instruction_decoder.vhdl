library ieee;
use ieee.std_logic_1164.all;

entity instruction_decoder is
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
end instruction_decoder;

architecture behav of instruction_decoder is
    signal opcode : std_logic_vector(2 downto 0);
    signal sub : std_logic_vector(1 downto 0);
begin
    -- Declare some CSA selection signals to drive other signals
    opcode <= instruction(7 downto 5);
    sub <= instruction(7 downto 6);
    
    process(opcode, sub, instruction) is begin
        print_control <= opcode(2) and opcode(1) and not opcode(0);
        operation_select <= opcode(2)  and (not opcode(1) or opcode(0));
        write_enable <= not (opcode(2) and opcode(1));
        write_data_select <= opcode(2) xor opcode(1);
    
        case(opcode) is
            when "111" =>
                if(instruction(0) = '1') then
                    skip_control<="10";
                else
                    skip_control<="01";
                end if;
                reg1 <= instruction(4 downto 3);
                reg2 <= instruction(2 downto 1);
            when "110"=>
                reg1<=instruction(4 downto 3);
            when others => skip_control <= "00";
        end case;
        
        case(sub) is
            when "00" => 
                immediate <= instruction(3 downto 0);
                write_address <= instruction(5 downto 4);
            when "01" =>
                write_address <= instruction(1 downto 0);
                reg1 <= instruction(5 downto 4);
                reg2 <= instruction(3 downto 2);
            when "10" =>
                write_address <= instruction(1 downto 0);
                reg1 <= instruction(5 downto 4);
                reg2 <= instruction(3 downto 2);
            when others=>null;
        end case;
    end process;
    
end behav;