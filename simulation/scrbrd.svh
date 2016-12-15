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

	// vm_in_monitor					vm_in_mon;
	// mailbox #(base_vm_transaction)	vm_in_mlb;

	// vm_out_monitor					vm_out_mon;
	// mailbox #(base_vm_transaction)	vm_out_mlb;

	// base_vm_transaction 			base_in_trn;
	// vm_mon_transaction				vm_in_trn;

	// base_vm_transaction 			base_out_trn;
	// vm_mon_transaction				vm_out_trn;

	// function new(
	// 				virtual dut_interface		dut_if,
	// 				virtual vm_in_interface 	vm_in_if,
	// 				virtual vm_out_interface 	vm_out_if
	// 			);

	// 	this.dut_if 	= 	dut_if;
	// 	this.vm_in_if 	= 	vm_in_if;
	// 	this.vm_out_if 	= 	vm_out_if;

	// 	vm_in_mlb 		=	new();
	// 	vm_in_mon 		= 	new(	
	// 								dut_if, 
	// 								vm_in_if.mon_port,
	// 								vm_in_mlb
	// 							);
		
	// 	vm_out_mlb 		= 	new();
	// 	vm_out_mon 		= 	new(	
	// 								dut_if,
	// 								vm_out_if.mon_port,
	// 								vm_out_mlb
	// 							);

	// 	fork
	// 		this.transaction_filter();
	// 	join_none

	// endfunction : new	

	// task transaction_filter();
	
	// endtask : transaction_filter

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