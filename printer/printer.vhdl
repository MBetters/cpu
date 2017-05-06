library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- A printer that prints the binary input signal to the terminal
entity printer is
    port(
        i: in std_logic_vector(7 downto 0); 
        print_control: in std_logic;
        disp_0: out std_logic_vector(3 downto 0);
        disp_1: out std_logic_vector(3 downto 0);
        disp_2: out std_logic_vector(3 downto 0);
        disp_3: out std_logic_vector(3 downto 0)
    );
end printer;

architecture behav of printer is
    component twos_complement
        port(
            input: in std_logic_vector(7 downto 0);
            output: out std_logic_vector(7 downto 0)
        );
    end component;
    signal disp_0_intermediate: std_logic_vector(3 downto 0);
    signal disp_1_intermediate: std_logic_vector(3 downto 0);
    signal disp_2_intermediate: std_logic_vector(3 downto 0);
    signal disp_3_intermediate: std_logic_vector(3 downto 0);
    signal i_comp: std_logic_vector(7 downto 0);
    signal i_magnitude: std_logic_vector(7 downto 0);
begin
    twos_comp: twos_complement port map(
        input => i,
        output => i_comp
    );
    i_magnitude <= i when i(7) = '0' else i_comp;
    process(i_magnitude) is
        variable s_digit_0: unsigned(3 downto 0);
        variable s_digit_1: unsigned(3 downto 0);
        variable s_digit_2: unsigned(3 downto 0);
        variable s_digit_3: unsigned(3 downto 0);
    begin
    if(print_control='1') then
            s_digit_3 := "0000";
            s_digit_2 := "0000";
            s_digit_1 := "0000";
            s_digit_0 := "0000";
            for k in 7 downto 0 loop
              if (s_digit_3 >= 5) then s_digit_3 := s_digit_3 + 3; end if;
              if (s_digit_2 >= 5) then s_digit_2 := s_digit_2 + 3; end if;
              if (s_digit_1 >= 5) then s_digit_1 := s_digit_1 + 3; end if;
              if (s_digit_0 >= 5) then s_digit_0 := s_digit_0 + 3; end if;
              s_digit_3 := s_digit_3 sll 1; s_digit_3(0) := s_digit_2(3);
              s_digit_2 := s_digit_2 sll 1; s_digit_2(0) := s_digit_1(3);
              s_digit_1 := s_digit_1 sll 1; s_digit_1(0) := s_digit_0(3);
              s_digit_0 := s_digit_0 sll 1; s_digit_0(0) := i_magnitude(k);
            end loop;
            
            disp_0 <= std_logic_vector(s_digit_0);
            if(i(7)='1' and s_digit_1 = 0 and s_digit_2 = 0) then
                disp_1<="1110";
            elsif(i(7)='0' and s_digit_1 = 0 and s_digit_2 = 0) then
                disp_1<="1111";
            else
                disp_1<=std_logic_vector(s_digit_1);
            end if;
            
            if(i(7)='1' and s_digit_2 = 0) then
                disp_2<="1110";
            elsif(i(7)='0' and s_digit_2 = 0) then
                disp_2<="1111";
            else
                disp_2<=std_logic_vector(s_digit_2);
            end if;
            
            if(i(7)= '1' and not (s_digit_1 = 0) and not (s_digit_2 = 0)) then
                disp_3<="1110";
            else
                disp_3<="1111";
            end if;
        end if;
    end process;
end behav;