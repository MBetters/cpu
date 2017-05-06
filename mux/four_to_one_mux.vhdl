library ieee;
use ieee.std_logic_1164.all;

entity four_to_one_mux is
    generic (wordLength: integer := 4);
    port (
        in0, in1, in2, in3 : in std_logic_vector(wordLength - 1 downto 0);
        sel: in std_logic_vector(1 downto 0);
        op : out std_logic_vector(wordLength - 1 downto 0));
end entity four_to_one_mux;

architecture behavioral of four_to_one_mux is begin
    process(sel) begin
        case sel is
            when "00" => op <= in0;
            when "01" => op <= in1;
            when "10" => op <= in2;
            when "11" => op <= in3;
            when others => op <= "11";
        end case;
    end process;
end architecture;