library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port(
        data1, data2: in std_logic_vector(7 downto 0);
        op : in std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end alu;

architecture struc of alu is
    component arithmetic
        port(
            inp1:	in std_logic_vector (7 downto 0);
            inp2:	in std_logic_vector (7 downto 0);
            initial_carry : in std_logic; -- 1 for subtract, 0 for add
            outp:   out std_logic_vector (7 downto 0);
            underflow: out std_logic;
            overflow: out std_logic
        );
    end component;
begin
    
    add : arithmetic port map(inp1 => data1, 
                              inp2 => data2, 
                              initial_carry => op, 
                              outp => result, 
                              underflow => open, 
                              overflow => open);
end struc;