library ieee;
use ieee.std_logic_1164.all;

entity two_to_one_mux is
    generic (wordLength: integer := 4);
    port (
        in0, in1: in std_logic_vector(wordLength - 1 downto 0);
        sel: in std_logic;
        op : out std_logic_vector(wordLength - 1 downto 0));
end entity two_to_one_mux;

architecture behavioral of two_to_one_mux is begin
    process(sel) begin
        case sel is
            when '0' => op <= in0;
            when '1' => op <= in1;
            when others => op <= "00";
        end case;
    end process;
end architecture;