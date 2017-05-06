all:
	ghdl -a *.vhdl
	#Instruction Decoder
	ghdl -e instruction_decoder
	#Register File
	ghdl -e reg
	ghdl -e register_file
	#ALU
	ghdl -e arithmetic
	ghdl -e alu
	#Clock Generator
	ghdl -e two_bit_reg
	ghdl -e clock_generator
	#Sign Extender
	ghdl -e sign_extender
	#Printer
	ghdl -e twos_complement
	ghdl -e printer
	#CPU
	ghdl -e cpu
	#CPU Testbench
	ghdl -e cpu_tb_alt
	ghdl -r cpu_tb_alt 2> outputs.txt
	echo "*****************"
	grep NUMERIC_STD -v outputs.txt #Run the testbench

clean:
	ghdl --clean
	
