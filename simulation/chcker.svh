/*
 *	File: chcker.svh  
 *	
 *	This file contains description of checker class
 *
*/

`ifndef __CHECKER_COMMON__
`define __CHECKER_COMMON__

class checkr_comm;
  static int unsigned err_cnt;
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
		int 	product_price;
		int 	real_change;
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
						case (vm_in_trn.product_code)
							1:	product_price = vm_parameter::PRICE_PROD_ONE;
							2:	product_price = vm_parameter::PRICE_PROD_TWO;	   
							3:	product_price = vm_parameter::PRICE_PROD_THREE;
							4:	product_price = vm_parameter::PRICE_PROD_FOUR; 
							5:	product_price = vm_parameter::PRICE_PROD_FIVE; 
							6:	product_price = vm_parameter::PRICE_PROD_SIX;  
							7:	product_price = vm_parameter::PRICE_PROD_SEVEN;
							8:	product_price = vm_parameter::PRICE_PROD_EIGHT;
							default : product_price = 0;
						endcase

						if (vm_in_trn.money - product_price != vm_out_trn.money) 
						begin
							real_change = vm_in_trn.money - product_price;
							$display("[%t][CHKR][ERR] Change does not match: Exp[%2d], Got[%2d]",$time(), real_change, vm_out_trn.money);
							checkr_comm::err_cnt++;
						end
					end else begin
						$display("[%t][CHCK][ERR] Product code does not match: Ext[%2d]",vm_in_trn.product_code, vm_out_trn.product_code);
						checkr_comm::err_cnt++;
					end
				end
			end
		end
	endtask : run_check

endclass : vm_checker

`endif //__CHECKER__
