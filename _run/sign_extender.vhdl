library ieee;
use ieee.std_logic_1164.all;

-- A 4-bit to 8-bit sign extender
entity sign_extender is
    port(
        i: in std_logic_vector(3 downto 0); -- input
        o: out std_logic_vector(7 downto 0) -- output
    );
end sign_extender;

architecture behav of sign_extender is
begin
    o(7 downto 4) <= "0000" when i(3) = '0' else
                     "1111" when i(3) = '1';
    o(3 downto 0) <= i(3 downto 0);
end behav;