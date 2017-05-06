library ieee;
use ieee.std_logic_1164.all;

entity arithmetic is
port(	inp1:	in std_logic_vector (7 downto 0);
        inp2:	in std_logic_vector (7 downto 0);
        initial_carry : in std_logic; -- 1 for subtract, 0 for add
        outp:   out std_logic_vector (7 downto 0);
        underflow: out std_logic;
        overflow: out std_logic
);
end arithmetic;

architecture behav of arithmetic is
	component full_adder
		port (
        a, b, cin : in  std_logic;
        sum, cout : out std_logic
    	);
	end component;
	-- carry is used for the actual sum carry 
	-- carry_arg is used for the twos complement carry
    signal carry, summation, arg2 : std_logic_vector(7 downto 0);
    -- arg2 is the second argument of the sum, it is dependent on the operation
    -- inv2 is the inversion of the second input
    -- temp is the twos_complement output temporary variable
begin
	fa0 : full_adder port map (a => inp1(0), b => arg2(0), cin => initial_carry, sum => summation(0), cout => carry(0));
	fa1 : full_adder port map (a => inp1(1), b => arg2(1), cin => carry(0), sum => summation(1), cout => carry(1));
	fa2 : full_adder port map (a => inp1(2), b => arg2(2), cin => carry(1), sum => summation(2), cout => carry(2));
	fa3 : full_adder port map (a => inp1(3), b => arg2(3), cin => carry(2), sum => summation(3), cout => carry(3));
	
	fa4 : full_adder port map (a => inp1(4), b => arg2(4), cin => carry(3), sum => summation(4), cout => carry(4));
	fa5 : full_adder port map (a => inp1(5), b => arg2(5), cin => carry(4), sum => summation(5), cout => carry(5));
	fa6 : full_adder port map (a => inp1(6), b => arg2(6), cin => carry(5), sum => summation(6), cout => carry(6));
	fa7 : full_adder port map (a => inp1(7), b => arg2(7), cin => carry(6), sum => summation(7), cout => carry(7));
	
	outp <= summation;
	arg2(0) <= inp2(0) xor initial_carry;
	arg2(1) <= inp2(1) xor initial_carry;
	arg2(2) <= inp2(2) xor initial_carry;
	arg2(3) <= inp2(3) xor initial_carry;
	arg2(4) <= inp2(4) xor initial_carry;
	arg2(5) <= inp2(5) xor initial_carry;
	arg2(6) <= inp2(6) xor initial_carry;
	arg2(7) <= inp2(7) xor initial_carry;
	
	overflow <= (not inp1(7) and not arg2(7) and summation(7));
	underflow <=  (inp1(7) and arg2(7) and not summation(7));
end behav;