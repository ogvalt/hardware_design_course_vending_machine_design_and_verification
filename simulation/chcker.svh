/*
 *	File: chcker.svh  
 *	
 *	This file contains description of checker class
 *
*/

`ifndef __CHECKER_COMMON__
`define __CHECKER_COMMON__

class checkr_comm;
  static int unsigned err_cnt;		// total number of error
  static int unsigned err_change;	// change errors conter
  static int unsigned err_product;	// product errors conter

  static int unsigned pass_cnt;		// total passed checks
  static int unsigned pass_change;	// passed change checks
  static int unsigned pass_product; // passed product ckecks
endclass : checkr_comm

`endif // __CHECKER_COMMON__


`ifndef __CHECKER__
`define __CHECKER__

`include "./simulation/if.svh"
`include "./simulation/vm_uvc.svh"
`include "./simulation/vm_parameter.svh"

import vm_parameter::*;

class vm_checker;

	virtual 	dut_interface 		dut_if;
	virtual		vm_in_interface 	vm_in_if;
	virtual		vm_out_interface	vm_out_if;

	vm_in_monitor					vm_in_mon;
	mailbox #(base_vm_transaction)	vm_in_mlb;

	vm_out_monitor					vm_out_mon;
	mailbox #(base_vm_transaction)	vm_out_mlb;

	base_vm_transaction 			base_in_trn;
	vm_mon_transaction				vm_in_trn;

	base_vm_transaction 			base_out_trn;
	vm_mon_transaction				vm_out_trn;

	function new(
					virtual dut_interface		dut_if,
					virtual vm_in_interface 	vm_in_if,
					virtual vm_out_interface 	vm_out_if
				);
	

		this.dut_if 	= 	dut_if;
		this.vm_in_if 	= 	vm_in_if;
		this.vm_out_if 	= 	vm_out_if;

		vm_in_mlb 		=	new();
		vm_in_mon 		= 	new(	
									dut_if, 
									vm_in_if.mon_port,
									vm_in_mlb
								);
		
		vm_out_mlb 		= 	new();
		vm_out_mon 		= 	new(	
									dut_if,
									vm_out_if.mon_port,
									vm_out_mlb
								);

		fork
			this.run_check();
		join_none
	endfunction : new

	task run_check();
		forever 
		begin
			vm_in_mlb.get(base_in_trn);

			if ($cast(vm_in_trn, base_in_trn)) 
			begin
				vm_out_mlb.get(base_out_trn);

				if($cast(vm_out_trn, base_out_trn)) 
				begin

					if(vm_in_trn.product_code == vm_out_trn.product_code) 
					begin
						if (common::exp_change != vm_out_trn.money) 
						begin
							$display("[%t][CHKR][ERR] Change does not match: Exp[%2d], Got[%2d]",$time(), common::exp_change, vm_out_trn.money);
							checkr_comm::err_cnt++;
							checkr_comm::err_change++;
						end else 
						begin
							$display("[%t][CHCK][INFO] Change match. OK",$time());
							checkr_comm::pass_cnt++;
							checkr_comm::pass_change++;
						end

						$display("[%t][CHCK][INFO] Product match. OK",$time());
						checkr_comm::pass_cnt++;
						checkr_comm::pass_product++;
					end else 
					begin
						$display("[%t][CHCK][ERR] Product code does not match: Ext[%2d], Got[%2d]",$time(), vm_in_trn.product_code, vm_out_trn.product_code);
						checkr_comm::err_cnt++;
						checkr_comm::err_product++;
					end
				end
			end
		end
	endtask : run_check

endclass : vm_checker

`endif //__CHECKER__
