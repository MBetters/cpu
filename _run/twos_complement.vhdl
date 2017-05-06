library ieee;
use ieee.std_logic_1164.all;

-- A printer that prints the binary input signal to the terminal
entity twos_complement is
    port(
        input: in std_logic_vector(7 downto 0);
        output: out std_logic_vector(7 downto 0)
    );
end twos_complement;

architecture behav of twos_complement is
component arithmetic
    port(	inp1:	in std_logic_vector (7 downto 0);
            inp2:	in std_logic_vector (7 downto 0);
            initial_carry : in std_logic; -- 1 for subtract, 0 for add
            outp:   out std_logic_vector (7 downto 0);
            underflow: out std_logic;
            overflow: out std_logic
    );
end component;
signal zero : std_logic_vector(7 downto 0);
begin
    zero<="00000000";
    ar : arithmetic  port map(
        inp1=>zero,
        inp2=>input,
        initial_carry=>'1',
        outp=>output,
        underflow=>open,
        overflow=>open
    );
end behav;