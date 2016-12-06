/*
 *	File: vm_uvc.sv
 *
 *	This file contains UVC description
 *
 *
*/

`include "./simulation/if.svh"

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

class vm_transaction extends base_vm_transaction;

	rand logic [3:0] money;
	rand logic [3:0] product_code;

	constraint c_money_code {
		money inside {[1:15]};
	}

	constraint c_product_code {
		product_code inside {[1:8]}
	}

	function new();
	
	endfunction : new

endclass

`endif // __VM_TRANSACTION__

`ifndef __VM_DRIVER__
`define __VM_DRIVER__

class vm_driver;

	virtual dut_interface 			dut_port;
	virtual vm_interface.drv_port	vm_drv_port;

	mailbox #(base_vm_transaction) 	trn_mlb;

	semaphore 						trn_done;

	base_vm_transaction				base_trn;
	vm_transaction 					vm_trn;

	function new();
		

		fork
			this.run_driver();
		join_none
	endfunction : new

	task run_driver();
	
	endtask : run_driver


endclass : vm_uvc

`endif //__VM_DRIVER__