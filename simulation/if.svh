/*
 *	File: if.svh
 *	
 *	Header file with interface description
 *	Interface:
 *		- dut_interface - common interface for clock and reset signal thought all testbench
 *		- vm_in_interface - interface that provide signal transfer signal inside DUT
 *		- vm_out_interface - interface that provide signal transfer from DUT
 *	
*/

`ifndef __DUT_IF__
`define __DUT_IF__

interface dut_interface();

	logic 		clk;
	logic 		rst;

endinterface: dut_interface

`endif //__DUT_IF__

`ifndef __VM_IN_IF__
`define __VM_IN_IF__

interface vm_in_interface();
							
	logic 	[3:0]	money;
	logic 			money_valid;
	logic 	[3:0]	product_code;
	logic 			buy;		
	logic 			product_ready;

	modport drv_port 	(
							output 		money,
							output 		money_valid,
							output 		product_code,
							output 		buy,
							output 		product_ready
						);

	modport mon_port 	(
							input 		money,
							input 		money_valid,
							input 		product_code,
							input 		buy,
							input 		product_ready
						);
	
endinterface: vm_in_interface

`endif //__VM_IF__

`ifndef __VM_OUT_IF__
`define __VM_OUT_IF__

interface vm_out_interface();

	logic 	[3:0]	ready_product_code;
	logic 			product_valid;
	logic 			busy;			
	logic 	[3:0]	change_denomination_code;
	logic 			change_valid;	
	logic 			no_change;

	modport mon_port 	(
							input 	ready_product_code,
							input 	product_valid,
							input 	busy,
							input 	change_denomination_code,
							input 	change_valid,
							input 	no_change
						);

endinterface: vm_out_interface

`endif //__VM_OUT_IF__
