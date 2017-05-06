library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

use work.all;
 
entity printer_tb is
end entity printer_tb;

architecture dataflow of printer_tb is
    --Component(s)
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
    --Signal(s)
    signal inp : std_logic_vector(7 downto 0);
    signal pc : std_logic;
    signal d0, d1, d2, d3 : std_logic_vector(3 downto 0);
begin
    
    printer_instance : printer 
        port map(i=>inp,
        print_control=>pc,
        disp_0=>d0,
        disp_1=>d1,
        disp_2=>d2,
        disp_3=>d3);
    testprocess: process is begin
        --Basic test
        pc<='1', '0' after 19 ns;
        inp<="00000000", "00001111" after 4 ns, "10001111" after 9 ns, "10101010" after 14 ns, "00000000" after 19 ns, "10001111" after 24 ns;
        wait for 1 ns;
        assert false report "Input 0: PC: 1" severity note;
        
		assert d0 = "0000" report "Wrong Digit 0" severity error;
		assert false report integer'image(to_integer(unsigned(d0))) severity note;
		assert d1 = "1111" report "Wrong Digit 1" severity error;
		assert false report integer'image(to_integer(unsigned(d1))) severity note;
		assert d2 = "1111" report "Wrong Digit 2" severity error;
		assert false report integer'image(to_integer(unsigned(d2))) severity note;
		assert d3 = "1111" report "Wrong Digit 3" severity error;
		assert false report integer'image(to_integer(unsigned(d3))) severity note;
		
		assert false report "" severity note;
		assert false report "Input 15: PC: 1" severity note;
        wait for 5 ns;
		assert d0 = "0101" report "Wrong Digit 0" severity error;
		assert false report integer'image(to_integer(unsigned(d0))) severity note;
		assert d1 = "0001" report "Wrong Digit 1" severity error;
		assert false report integer'image(to_integer(unsigned(d1))) severity note;
		assert d2 = "1111" report "Wrong Digit 2" severity error;
		assert false report integer'image(to_integer(unsigned(d2))) severity note;
		assert d3 = "1111" report "Wrong Digit 3" severity error;
		assert false report integer'image(to_integer(unsigned(d3))) severity note;
		
		assert false report "" severity note;
		assert false report "Input -113: PC: 1" severity note;
		wait for 5 ns;
		assert d0 = "0011" report "Wrong Digit 0" severity error;
		assert false report integer'image(to_integer(unsigned(d0))) severity note;
		assert d1 = "0001" report "Wrong Digit 1" severity error;
		assert false report integer'image(to_integer(unsigned(d1))) severity note;
		assert d2 = "0001" report "Wrong Digit 2" severity error;
		assert false report integer'image(to_integer(unsigned(d2))) severity note;
		assert d3 = "1110" report "Wrong Digit 3" severity error;
		assert false report integer'image(to_integer(unsigned(d3))) severity note;
		
		assert false report "" severity note;
		assert false report "Input -86: PC: 1" severity note;
		wait for 5 ns;
		assert d0 = "0110" report "Wrong Digit 0" severity error;
		assert false report integer'image(to_integer(unsigned(d0))) severity note;
		assert d1 = "1000" report "Wrong Digit 1" severity error;
		assert false report integer'image(to_integer(unsigned(d1))) severity note;
		assert d2 = "1110" report "Wrong Digit 2" severity error;
		assert false report integer'image(to_integer(unsigned(d2))) severity note;
		assert d3 = "1111" report "Wrong Digit 3" severity error;
		assert false report integer'image(to_integer(unsigned(d3))) severity note;

        assert false report "" severity note;
		assert false report "Input 0: PC: 0" severity note;
		wait for 5 ns;
		assert d0 = "0110" report "Wrong Digit 0" severity error;
		assert false report integer'image(to_integer(unsigned(d0))) severity note;
		assert d1 = "1000" report "Wrong Digit 1" severity error;
		assert false report integer'image(to_integer(unsigned(d1))) severity note;
		assert d2 = "1110" report "Wrong Digit 2" severity error;
		assert false report integer'image(to_integer(unsigned(d2))) severity note;
		assert d3 = "1111" report "Wrong Digit 3" severity error;
		assert false report integer'image(to_integer(unsigned(d3))) severity note;

        assert false report "" severity note;
		assert false report "Input -113: PC: 0" severity note;
		wait for 5 ns;
		assert d0 = "0110" report "Wrong Digit 0" severity error;
		assert false report integer'image(to_integer(unsigned(d0))) severity note;
		assert d1 = "1000" report "Wrong Digit 1" severity error;
		assert false report integer'image(to_integer(unsigned(d1))) severity note;
		assert d2 = "1110" report "Wrong Digit 2" severity error;
		assert false report integer'image(to_integer(unsigned(d2))) severity note;
		assert d3 = "1111" report "Wrong Digit 3" severity error;
		assert false report integer'image(to_integer(unsigned(d3))) severity note;
		assert false report "end of test" severity note;
		--  Wait forever; this will finish the simulation.
		wait;
    end process testprocess;
    
end architecture dataflow;