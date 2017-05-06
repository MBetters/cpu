all:
	ghdl -a reg.vhdl
	ghdl -e reg
	ghdl -a register_file.vhdl
	ghdl -e register_file
	ghdl -a register_file_tb.vhdl
	ghdl -e register_file_tb
	ghdl -r register_file_tb
	
clean:
	ghdl --clean