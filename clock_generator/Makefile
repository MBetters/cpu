all:
	ghdl -a two_bit_reg.vhdl
	ghdl -e two_bit_reg
	ghdl -a clock_generator.vhdl
	ghdl -e clock_generator
	ghdl -a clock_generator_tb.vhdl
	ghdl -e clock_generator_tb
	ghdl -r clock_generator_tb --vcd=clock_generator_tb.vcd
	
clean:
	ghdl --clean