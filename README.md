# Component Testing
Every component has its own folder, with the component and sub-component VHDL files, as well as a test-bench VHDL file that tests the component.
To test a component, change into the directory, then run the following:
```
ghdl -a *.vhdl
ghdl -e <sub-component 1>
ghdl -e <sub-component 2>
... etc. (Elaborate all the sub-components)
ghdl -e <component>
ghdl -e <component>_tb
ghdl -r <component>_tb
```
If the test doesn't complain about any "bad output values," then it passed.

# System Testing
To test the whole CPU, change into the ```_run``` directory, then run ```make -i```, which will compile all of the components (and their sub-components), then compile the CPU, then compile and run the CPU test-bench.
The CPU can be tested for several different benchmarks. Each benchmark proves some aspect of an instruction works if the benchmark causes the CPU output to match the corresponding expected output found in ```_run/benchmarks/expected_outputs```.
To test the CPU for a given benchmark, copy and paste the machine code vectors from whichever benchmark you wish to test (found in ```_run/benchmarks/machine_code/<some benchmark>.txt```) into the ```instruction_instance``` constant in ```_run/cpu_tb_alt.vhdl```, making sure to put double quotes around the vectors and commas between them, then change the max index of the instructions_arr type-definition, then save those changes, then run ```make -i```. If the CPU output is the same as the expected output, then the benchmark passed.
Benchmarks should be run in the following order:
lui benchmarks --> print benchmarks --> add/sub benchmarks --> cmp benchmarks
