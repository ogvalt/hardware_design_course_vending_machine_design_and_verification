/*
 *	File: vm_uvc.svh
 *
 *	This file contains UVC description
 *
 *
*/

`include "./simulation/if.svh"

`include "./simulation/vm_parameter.svh"

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

	rand integer 	 	money_sequence[];
	/*
		концепція наступна генерувати послідовність у вигляді кодів номіналів,
		якщо їх буде мало вкінень додати код найбільшого номіналу. роби простіше.

	*/
	rand logic [ 3:0] 	product_code;
	integer 		  	wait_before_trn_ends; 	

	constraint c_money_sequence_len {
		money_sequence.size inside {[1:100]};
	}

	constraint c_money_sequence_value {
		foreach (money_sequence[i]) money_sequence[i] inside {[1:15]};
	}

	constraint c_product_code {
		product_code inside {[1:8]};
	}

	function new();
	
	endfunction : new

	function void post_randomize();
		integer 	sum;
		integer 	product_price;

		sum 	= 0;
		foreach (money_sequence[i]) begin

			case (money_sequence[i])
				vm_parameter::DENOMINATION_CODE_500	: 	sum +=	vm_parameter::DENOMINATION_VALUE_500;	 
			 	vm_parameter::DENOMINATION_CODE_200	:	sum +=	vm_parameter::DENOMINATION_VALUE_200;
			   	vm_parameter::DENOMINATION_CODE_100	:	sum +=	vm_parameter::DENOMINATION_VALUE_100;
			   	vm_parameter::DENOMINATION_CODE_50  :	sum +=	vm_parameter::DENOMINATION_VALUE_50;
			   	vm_parameter::DENOMINATION_CODE_20  :	sum +=	vm_parameter::DENOMINATION_VALUE_20;
			   	vm_parameter::DENOMINATION_CODE_10  :	sum +=	vm_parameter::DENOMINATION_VALUE_10;
			   	vm_parameter::DENOMINATION_CODE_5   :	sum +=	vm_parameter::DENOMINATION_VALUE_5;
			   	vm_parameter::DENOMINATION_CODE_2   :	sum +=	vm_parameter::DENOMINATION_VALUE_2;
			   	vm_parameter::DENOMINATION_CODE_1   :	sum +=	vm_parameter::DENOMINATION_VALUE_1;
			   	vm_parameter::DENOMINATION_CODE0_50 :	sum +=	vm_parameter::DENOMINATION_VALUE_0_50;
			   	vm_parameter::DENOMINATION_CODE0_25 :	sum +=	vm_parameter::DENOMINATION_VALUE_0_25;	
			   	vm_parameter::DENOMINATION_CODE0_10 :	sum +=	vm_parameter::DENOMINATION_VALUE_0_10;
			   	vm_parameter::DENOMINATION_CODE0_05 :	sum +=	vm_parameter::DENOMINATION_VALUE_0_05;
			   	vm_parameter::DENOMINATION_CODE0_02 :	sum +=	vm_parameter::DENOMINATION_VALUE_0_02;
			   	vm_parameter::DENOMINATION_CODE0_01 :	sum +=	vm_parameter::DENOMINATION_VALUE_0_01;
			endcase

		end

		case (product_code)
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

		if (sum < product_price)
			money_sequence = {money_sequence,1};
	
	endfunction : post_randomize

endclass : vm_drv_transaction

class vm_mon_transaction extends base_vm_transaction;

	logic 	[20:0] 	change;
	integer			money_sequence[$:100];
	logic 	[ 3:0] 	product_code;
	logic 			no_change;
	time 			at_time;

	function new();
		money_sequence = {};
	endfunction : new

	function void sequence_to_change();
		change = 0;
		foreach (money_sequence[i]) begin
			case (money_sequence[i])
				vm_parameter::DENOMINATION_CODE_500	: 	change +=	vm_parameter::DENOMINATION_VALUE_500;	 
			 	vm_parameter::DENOMINATION_CODE_200	:	change +=	vm_parameter::DENOMINATION_VALUE_200;
			   	vm_parameter::DENOMINATION_CODE_100	:	change +=	vm_parameter::DENOMINATION_VALUE_100;
			   	vm_parameter::DENOMINATION_CODE_50  :	change +=	vm_parameter::DENOMINATION_VALUE_50;
			   	vm_parameter::DENOMINATION_CODE_20  :	change +=	vm_parameter::DENOMINATION_VALUE_20;
			   	vm_parameter::DENOMINATION_CODE_10  :	change +=	vm_parameter::DENOMINATION_VALUE_10;
			   	vm_parameter::DENOMINATION_CODE_5   :	change +=	vm_parameter::DENOMINATION_VALUE_5;
			   	vm_parameter::DENOMINATION_CODE_2   :	change +=	vm_parameter::DENOMINATION_VALUE_2;
			   	vm_parameter::DENOMINATION_CODE_1   :	change +=	vm_parameter::DENOMINATION_VALUE_1;
			   	vm_parameter::DENOMINATION_CODE0_50 :	change +=	vm_parameter::DENOMINATION_VALUE_0_50;
			   	vm_parameter::DENOMINATION_CODE0_25 :	change +=	vm_parameter::DENOMINATION_VALUE_0_25;	
			   	vm_parameter::DENOMINATION_CODE0_10 :	change +=	vm_parameter::DENOMINATION_VALUE_0_10;
			   	vm_parameter::DENOMINATION_CODE0_05 :	change +=	vm_parameter::DENOMINATION_VALUE_0_05;
			   	vm_parameter::DENOMINATION_CODE0_02 :	change +=	vm_parameter::DENOMINATION_VALUE_0_02;
			   	vm_parameter::DENOMINATION_CODE0_01 :	change +=	vm_parameter::DENOMINATION_VALUE_0_01;
			endcase
		end
	endfunction : sequence_to_change

endclass : vm_mon_transaction

`endif // __VM_TRANSACTION__

`ifndef __VM_DRIVER__
`define __VM_DRIVER__

class vm_driver;

	virtual dut_interface 				dut_port;
	virtual vm_in_interface.drv_port	drv_port;

	mailbox #(base_vm_transaction) 		trn_mlb;

	semaphore 							trn_done;

	base_vm_transaction					base_trn;
	vm_drv_transaction					vm_trn;

	function new(
					virtual dut_interface 				dut_port,
					virtual vm_in_interface.drv_port 	drv_port,
				 	mailbox #(base_vm_transaction) 		trn_mlb,
				 	semaphore 							trn_done
				);

		this.dut_port 	= 	dut_port;
		this.drv_port 	=	drv_port;
		this.trn_mlb 	=	trn_mlb;
		this.trn_done 	= 	trn_done;	

		// Init vm ports
		drv_port.money 			= 0;
		drv_port.money_valid 	= 0;
		drv_port.product_code 	= 0;
		drv_port.buy 			= 0;
		drv_port.product_ready 	= 0;

		fork
			this.run_driver();
		join_none

	endfunction : new

	task run_driver();
		
		forever begin 
			trn_mlb.get(base_trn);

			if($cast(vm_trn, base_trn)) begin
				drive_trn(vm_trn);
			end
			else begin
				$display("[%t][VM_DRIVER][ERR] Unknown transaction in Driver. TypeName: %s",$time, $typename(vm_trn));
			end

			trn_done.put();
		end
	endtask : run_driver

	task drive_trn (vm_drv_transaction vm_trn);

		drv_port.product_code 	= 	vm_trn.product_code;
		drv_port.buy 			=	1'b1;

		@(negedge dut_port.clk);

		drv_port.buy 			= 	1'b0;

		foreach (vm_trn.money_sequence[i]) begin
			@(negedge dut_port.clk);
			drv_port.money 			= vm_trn.money_sequence[i];
			drv_port.money_valid	= 1'b1;
		end

		@(negedge dut_port.clk);
		drv_port.money_valid 	= 1'b0;
		drv_port.product_ready	= 1'b1;
		@(negedge dut_port.clk);
		drv_port.product_ready 	= 1'b0;

		repeat(vm_trn.wait_before_trn_ends)
			@(negedge dut_port.clk);
		
	endtask : drive_trn


endclass : vm_driver

`endif //__VM_DRIVER__

`ifndef __VM_MONITOR__
`define __VM_MONITOR__

class vm_monitor;

	virtual dut_interface 				dut_port;
	virtual vm_out_interface.mon_port	mon_port;

	mailbox #(base_vm_transaction) 	trn_mlb;

	vm_mon_transaction 				vm_trn;

	function new(
					virtual dut_interface 				dut_port,
					virtual vm_out_interface.mon_port	mon_port,
					mailbox #(base_vm_transaction) 		trn_mlb
				);

		this.dut_port 	= 	dut_port;
		this.mon_port 	= 	mon_port;
		this.trn_mlb 	= 	trn_mlb;

		fork
			this.run_monitor();
		join_none
	endfunction : new

	task run_monitor();
		fork
			transaction_processing();
		join_none
	endtask : run_monitor

	task transaction_processing();
		
		forever begin

			@(posedge mon_port.product_valid);
			@(negedge dut_port.clk);

			vm_trn.product_code = mon_port.ready_product_code;

			@(posedge mon_port.change_valid);
			@(negedge dut_port.clk);

			if (mon_port.no_change === 1'b1) begin
				vm_trn.no_change 	= 1'b1;
			end else begin
				while(mon_port.change_valid===1'b1 & mon_port.no_change!==1'b1) begin
					vm_trn.money_sequence = {vm_trn.money_sequence, mon_port.change_denomination_code};
					@(negedge dut_port.clk);
				end
				vm_trn.no_change 	= mon_port.no_change ? 1'b1 : 1'b0;
			end
			vm_trn.at_time 		= $time();

			vm_trn.sequence_to_change();

			$display("[%t][VM_MONITOR][INFO] Monitor get transaction. Product_code [%d]",$time(),vm_trn.product_code);
			trn_mlb.put(vm_trn);
		end
	endtask : transaction_processing


endclass : vm_monitor

`endif //__VM_MONITOR__

/* transactor or agent */

`ifndef __VM_TRANSACTOR__
`define __VM_TRANSACTOR__

class vm_transactor;

	virtual dut_interface			dut_if;
	virtual vm_in_interface 		vm_if;

	mailbox	#(base_vm_transaction) 	trn_mlb;

	semaphore 						trn_done;
	vm_driver 						vm_drv;
	vm_drv_transaction 				trn;

	function new(
					virtual dut_interface 	dut_if,
					virtual vm_in_interface vm_if
				);

		this.dut_if 	=	dut_if;
		this.vm_if 		= 	vm_if;

		trn_mlb 		= 	new();
		trn_done 		=	new();

		vm_drv 			= 	new(dut_if,	vm_if.drv_port,	trn_mlb, trn_done);
	
	endfunction : new

	task vm_random_trn();
		
		$display("[%t][VM_TRN][INFO] VM Random Transaction",$time());

		trn = new();
		if (trn.randomize() == 1) begin
			trn_mlb.put(trn); 	// send transaction to driver
			trn_done.get();		// wait until driver done

			$write("[%t][VM_TRN][INFO] VM Transaction has been sent. Product_code[%d]. Money sequence: ", $time(), trn.product_code);
			foreach (trn.money_sequence[i]) begin
				$write("%d ", trn.money_sequence[i]);
			end
			$write("\n");
		end else begin
			$display("[%t][VM_TRN][ERR] Something go wrong with randomize()",$time());
		end
	endtask : vm_random_trn

	task vm_random_money_sq(logic [3:0] code);
		
		$display("[%t][VM_TRN][INFO] VM Transaction with random money sequence",$time());

		trn = new();

		assert (trn.randomize() with {
			this.product_code == code;
		});

		trn_mlb.put(trn); 	// send transaction to driver
		trn_done.get();		// wait until driver done

		$write("[%t][VM_TRN][INFO] VM Transaction has been sent. Product_code[%d]. Money sequence: ", $time(), trn.product_code);
		foreach (trn.money_sequence[i]) begin
			$write("%d ", trn.money_sequence[i]);
		end
		$write("\n");
	endtask : vm_random_money_sq

	task vm_random_product(int seq[]);

		$display("[%t][VM_TRN][INFO] VM Transaction with random product",$time());

		trn = new();

		assert(trn.randomize() with {
			this.money_sequence == seq;
		});
		
		trn_mlb.put(trn); 	// send transaction to driver
		trn_done.get();		// wait until driver done

		$write("[%t][VM_TRN][INFO] VM Transaction has been sent. Product_code[%d]. Money sequence: ", $time(), trn.product_code);
		foreach (trn.money_sequence[i]) begin
			$write("%d ", trn.money_sequence[i]);
		end
		$write("\n");
	endtask : vm_random_product

	task vm_non_randon_trn(	int seq[],	logic [3:0] code);

		$display("[%t][VM_TRN][INFO] VM Non Random Transaction",$time());

		trn = new();

		assert(trn.randomize() with {
			this.money_sequence == seq;
			this.product_code 	== code;
		});
		
		trn_mlb.put(trn); 	// send transaction to driver
		trn_done.get();		// wait until driver done

		$write("[%t][VM_TRN][INFO] VM Transaction has been sent. Product_code[%d]. Money sequence: ", $time(), trn.product_code);
		foreach (trn.money_sequence[i]) begin
			$write("%d ", trn.money_sequence[i]);
		end
		$write("\n");
	endtask : vm_non_randon_trn


endclass : vm_transactor

`endif //__VM_TRANSACTOR__
