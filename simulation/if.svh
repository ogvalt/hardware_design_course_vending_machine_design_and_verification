/*
 *	File: if.svh
 *	
 *	Header file with interface description
 *	Interface:
 *		- dut_interface - common interface for clock and reset signal thought all testbench
 *		- vm_interface 	- interface that provide driver-dut and dut-monitor communication
 *	
*/

`ifndef __DUT_IF__
`define __DUT_IF__

interface dut_interface (
							input clk,
							input rst
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

	logic 	[3:0]	ready_product_code;
	logic 			product_valid;
	logic 			busy;			
	logic 	[3:0]	change_denomination_code;
	logic 			change_valid;	
	logic 			no_change;

	modport drv_port 	(
							output 		money,
							output 		money_valid,
							output 		product_code,
							output 		buy,
							output 		product_ready
						);

	modport mon_port 	(
							input 	ready_product_code,
							input 	product_valid,
							input 	busy,
							input 	change_denomination_code,
							input 	change_valid,
							input 	no_change
						);
	
endinterface: vm_interface

`endif //__VM_IF__
