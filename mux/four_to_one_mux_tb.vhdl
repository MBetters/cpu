library ieee;
use ieee.std_logic_1164.all;

use work.all;
 
entity four_to_one_mux_tb is
end entity four_to_one_mux_tb;

architecture dataflow of four_to_one_mux_tb is
    --Component(s)
    component four_to_one_mux
        generic (wordLength: integer);
        port (
            in0, in1, in2, in3 : in std_logic_vector(wordLength - 1 downto 0);
            sel: in std_logic_vector(1 downto 0);
            op : out std_logic_vector(wordLength - 1 downto 0)
        );
    end component;
    component two_to_one_mux
        generic (wordLength: integer := 4);
        port (
            in0, in1: in std_logic_vector(wordLength - 1 downto 0);
            sel: in std_logic;
            op : out std_logic_vector(wordLength - 1 downto 0));
    end component;
    --Signal(s)
    signal inpzero, inpone, inptwo, inpthree, outp0, outp1 : std_logic_vector(2 downto 0);
    signal inpsel: std_logic_vector(1 downto 0);
begin
    
    four_to_one_mux_instance : four_to_one_mux 
        generic map(wordLength => 3)
        port map(in0 => inpzero, 
                 in1 => inpone, 
                 in2 => inptwo, 
                 in3 => inpthree, 
                 sel => inpsel, 
                 op => outp0);
    two_to_one_mux_instance : two_to_one_mux 
        generic map(wordLength => 3)
        port map(in0 => inpzero, 
                 in1 => inpone, 
                 sel => inpsel(1), 
                 op => outp1);
    inpzero  <= "000";
    inpone   <= "001";
    inptwo   <= "010";
    inpthree <= "100";
    
    testprocess: process is begin
        inpsel <= "00";
        wait for 10 ns;
		assert outp0 = "000" report "bad output value" severity error;
		assert outp1 = "000" report "bad output value" severity error;
		inpsel <= "01";
        wait for 10 ns;
		assert outp0 = "001" report "bad output value" severity error;
		assert outp1 = "000" report "bad output value" severity error;
		inpsel <= "10";
        wait for 10 ns;
		assert outp0 = "010" report "bad output value" severity error;
		assert outp1 = "001" report "bad output value" severity error;
		inpsel <= "11";
        wait for 10 ns;
		assert outp0 = "100" report "bad output value" severity error;
		assert outp1 = "001" report "bad output value" severity error;
		assert false report "end of test" severity note;
		--  Wait forever; this will finish the simulation.
		wait;
    end process testprocess;
    
end architecture dataflow;