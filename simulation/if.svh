/*
 *	File: if.svh
 *	
 *	Header file with interface description
 *
*/

`ifndef __DUT_IF__
`define __DUT_IF__

interface dut_interface (
							input clk;
							input rst;
						);

endinterface: dut_interface

`endif //__DUT_IF__

`ifndef __VM_IF__
`define __VM_IF__

interface vm_interface();
							
	logic 	[3:0]	money;
	logic 			money_valid;
	logic 	[3:0]	product_code;
	logic 			buy;		
	logic 			product_ready;

	logic 	[3:0]	o_product_code;
	logic 			o_product_valid;
	logic 			o_busy;			
	logic 	[3:0]	o_change_denomination_code;
	logic 			o_change_valid;	
	logic 			o_no_change;

	modport drv_port 	(
							output 		money;
							output 		money_valid;
							output 		product_code;
							output 		buy;		
							output 		product_ready;
						);
	
	modport mon_port 	(
							input 	product_code;
							input 	product_valid;
							input 	busy;			
							input 	change_denomination_code;
							input 	change_valid;	
							input 	no_change;
						);
endinterface: vm_interface

`endif //__VM_IF__
