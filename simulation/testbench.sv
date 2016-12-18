/*
 *	File: testbench.sv
 *	
 *	This file is top level testbench module
 *
*/

`include "./simulation/if.svh"
`include "./simulation/env.sv"
`include "./simulation/dut_top.sv"
`include "./simulation/assertions.sv"

module tb;

	dut_interface 		dut_if();
	vm_in_interface 	vm_in_if();
	vm_out_interface	vm_out_if();

	environment 		env(dut_if,vm_in_if,vm_out_if);
	dut_top				dut_top(dut_if,vm_in_if,vm_out_if);
	assertions			ass(dut_if,vm_in_if,vm_out_if);

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end

endmodule