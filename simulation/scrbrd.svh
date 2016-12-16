/*
 *	File: scrbrd.svh  
 *	
 *	This file contains description of scoreboard class
 *
*/


`ifndef __SCOREBOARD_SVH__
`define __SCOREBOARD_SVH__

`include "./simulation/if.svh"
`include "./simulation/vm_uvc.svh"
`include "./simulation/chcker.svh"

class scoreboard;

	virtual 	dut_interface 		dut_if;
	virtual		vm_in_interface 	vm_in_if;
	virtual		vm_out_interface	vm_out_if;

	vm_checker 	vm_checker;

	function new(
					virtual dut_interface		dut_if,
					virtual vm_in_interface 	vm_in_if,
					virtual vm_out_interface 	vm_out_if
				);

		this.dut_if 	=	dut_if;
		this.vm_in_if 	=	vm_in_if;
		this.vm_out_if 	=	vm_out_if;

		vm_checker 		= 	new(
									dut_if,
									vm_in_if,
									vm_out_if
								);
	endfunction : new

	function void report_final_status();
		
		$display("=======================================================\nFINAL REPORT");
		$display("\terr_cnt = %-d\n\terr_change = %-d\n\terr_product = %-d", 
					checkr_comm::err_cnt, checkr_comm::err_change, checkr_comm::err_product);
		$display("\tpass_cnt = %-d\n\tpass_change = %-d\n\tpass_product = %-d", 
					checkr_comm::pass_cnt, checkr_comm::pass_change, checkr_comm::pass_product);
		$display("\t%s\n\tTotal Coverage : %.1f%%", 			
             		(checkr_comm::err_cnt)?("FAIL"):("PASS"), $get_coverage());

	endfunction : report_final_status 

endclass : scoreboard
`endif //__SCOREBOARD_SVH__