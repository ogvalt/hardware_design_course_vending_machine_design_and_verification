/*
 *
 *	File: assertions.sv
 *
 *	This file contains assertions
 *
*/

`ifndef __ASSERTIONS_SV__
`define __ASSERTIONS_SV__

`include "./simulation/if.svh"

module	assertions(
					dut_interface 		dut,
					vm_in_interface 	in,
					vm_out_interface 	out
					);

	sequence seq_ready_valid;
  		in.product_ready ##1 out.product_valid;
 	endsequence

 	sequence seq_ready_busy;
 		in.product_ready ##1 out.busy;
 	endsequence

 	sequence seq_change_valid_no_change;
 		out.no_change ##0 out.change_valid;
 	endsequence

 	property pr_ready_valid;
 		@(posedge dut.clk)
 		disable iff (!dut.rst)
 		in.product_ready |-> seq_ready_valid;
 	endproperty

 	property pr_ready_busy;
 		@(posedge dut.clk)
 		disable iff (!dut.rst)
 		in.product_ready |-> seq_ready_busy;
 	endproperty

 	property pr_change_valid_no_change;
 		@(posedge dut.clk)
 		disable iff (!dut.rst)
 		out.no_change |-> seq_change_valid_no_change;
 	endproperty

 	as_ready_valid: assert property (pr_ready_valid) $display("[%t][ASSERT][INFO] Product_ready -> product_valid. OK",$time());
 					else $display("[%t][ASSERT][ERR] Product_ready -> product_valid",$time());

 	as_ready_busy: 	assert property (pr_ready_busy) $display("[%t][ASSERT][INFO] Product_ready -> busy. OK",$time());
 					else $display("[%t][ASSERT][ERR] Product_ready -> busy",$time());

 	as_change_valid_no_change: 	assert property(pr_change_valid_no_change) $display("[%t][ASSERT][INFO] change_valid -> no_change. OK",$time());
 								else $display("[%t][ASSERT][ERR] change_valid -> no_change",$time());

 	cov_ready_valid:	cover property (pr_ready_valid);

 	cov_ready_busy:	cover property (pr_ready_busy);

 	cov_change_valid_no_change: cover property(pr_change_valid_no_change);

endmodule

`endif //__ASSERTIONS_SV__