/*
 *	File: vm_uvc.sv
 *
 *	This file contains UVC description
 *
 *
*/

`include "./simulation/if.svh"

`include "./simulation/vm_parameter.sv"

import vm_parameter::*; //  is there can be a trouble of multiple import in several file (dut_top.sv) ???

`ifndef __VM_UVC_DEVICE__
`define __VM_UVC_DEVICE__

class base_vm_transaction;

	string 	name;

	function new();
		
		name = "base_vm_transaction";

	endfunction : new

endclass : base_vm_transaction

`endif // __VM_UVC_DEVICE__

`ifndef __VM_TRANSACTION__
`define __VM_TRANSACTION__

class vm_drv_transaction extends base_vm_transaction;

	rand integer 	 	money_array [1:15];					// money amount 
	rand logic [ 3:0] 	product_code;
	integer 		  	wait_before_trn; 	

	constraint c_money_array {
		foreach (money_array[i]) money_array[i] inside {[0:1000]};
	}

	constraint c_product_code {
		product_code inside {[1:8]}
	}

	function new();
	
	endfunction : new

	function void post_randomize();
		integer 	sum_of_money;
		integer 	product_price;

		sum 	= 0;
		foreach (money_array[i]) 	sum += money_array[i];

		case (product_code)
			1:	product_price = vm_parameter::PRICE_PROD_ONE  
			2:	product_price = vm_parameter::PRICE_PROD_TWO	   
			3:	product_price = vm_parameter::PRICE_PROD_THREE
			4:	product_price = vm_parameter::PRICE_PROD_FOUR 
			5:	product_price = vm_parameter::PRICE_PROD_FIVE 
			6:	product_price = vm_parameter::PRICE_PROD_SIX  
			7:	product_price = vm_parameter::PRICE_PROD_SEVEN
			8:	product_price = vm_parameter::PRICE_PROD_EIGHT
			default : product_price = 0;
		endcase

		if (sum < product_price)
			money_array[9] = product_price; // make  
	
	endfunction : post_randomize

endclass

class vm_mon_transaction extends base_vm_transaction;

	logic 	[20:0] 	change;
	logic 	[ 3:0] 	product_code;
	logic 			no_change;

	function new();
	
	endfunction : new

endclass : vm_mon_transaction

`endif // __VM_TRANSACTION__

`ifndef __VM_DRIVER__
`define __VM_DRIVER__

class vm_driver;

	virtual dut_interface 			dut_port;
	virtual vm_interface.drv_port	drv_port;

	mailbox #(base_vm_transaction) 	trn_mlb;

	semaphore 						trn_done;

	base_vm_transaction				base_trn;
	vm_transaction 					vm_trn;

	function new(
					virtual dut_interface 			dut_port,
					virtual vm_interface.drv_port 	drv_port,
				 	mailbox #(base_vm_transaction) 	trn_mlb,
				 	semaphore 						trn_done
				);

		this.dut_port 	= 	dut_port;
		this.drv_port 	=	drv_port;
		this.trn_mlb 	=	trn_mlb;
		this.trn_done 	= 	trn_done;	

		fork
			this.run_driver();
		join_none

	endfunction : new

	task run_driver();
	
	endtask : run_driver


endclass : vm_driver

`endif //__VM_DRIVER__

`ifndef __VM_MONITOR__
`define __VM_MONITOR__

class vm_monitor;

	virtual dut_interface 			dut_port;
	virtual vm_interface.mon_port	mon_port;

	function new();
	
	endfunction : new


endclass : vm_monitor
