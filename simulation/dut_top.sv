/*
 *	File: dut_top.sv
 *	
 *	Top level module of design
 *
*/

`ifndef	__DUT_TOP__
`define __DUT_TOP__

`include "./design/vending_machine.v"
`include "./simulation/vm_parameter.svh"
`include "./simulation/if.svh"

import vm_parameter::*;

module dut_top 	(
					dut_interface 	dut_if,
					vm_interface 	vm_if
				);

	vending_machine #(
					.PRICE_PROD_ONE  			(vm_parameter::PRICE_PROD_ONE  ),
					.PRICE_PROD_TWO  			(vm_parameter::PRICE_PROD_TWO  ),
					.PRICE_PROD_THREE			(vm_parameter::PRICE_PROD_THREE),
					.PRICE_PROD_FOUR 			(vm_parameter::PRICE_PROD_FOUR ),
					.PRICE_PROD_FIVE 			(vm_parameter::PRICE_PROD_FIVE ),
					.PRICE_PROD_SIX  			(vm_parameter::PRICE_PROD_SIX  ),
					.PRICE_PROD_SEVEN			(vm_parameter::PRICE_PROD_SEVEN),
					.PRICE_PROD_EIGHT			(vm_parameter::PRICE_PROD_EIGHT),

					.DENOMINATION_AMOUNT_500	(vm_parameter::DENOMINATION_AMOUNT_500),
					.DENOMINATION_AMOUNT_200	(vm_parameter::DENOMINATION_AMOUNT_200),
					.DENOMINATION_AMOUNT_100	(vm_parameter::DENOMINATION_AMOUNT_100),
					.DENOMINATION_AMOUNT_50 	(vm_parameter::DENOMINATION_AMOUNT_50 ),
					.DENOMINATION_AMOUNT_20 	(vm_parameter::DENOMINATION_AMOUNT_20 ),
					.DENOMINATION_AMOUNT_10 	(vm_parameter::DENOMINATION_AMOUNT_10 ),
					.DENOMINATION_AMOUNT_5  	(vm_parameter::DENOMINATION_AMOUNT_5  ),
					.DENOMINATION_AMOUNT_2  	(vm_parameter::DENOMINATION_AMOUNT_2  ),
					.DENOMINATION_AMOUNT_1  	(vm_parameter::DENOMINATION_AMOUNT_1  ),
					.DENOMINATION_AMOUNT0_50	(vm_parameter::DENOMINATION_AMOUNT0_50),
					.DENOMINATION_AMOUNT0_25	(vm_parameter::DENOMINATION_AMOUNT0_25),
					.DENOMINATION_AMOUNT0_10	(vm_parameter::DENOMINATION_AMOUNT0_10),
					.DENOMINATION_AMOUNT0_05	(vm_parameter::DENOMINATION_AMOUNT0_05),
					.DENOMINATION_AMOUNT0_02	(vm_parameter::DENOMINATION_AMOUNT0_02),
					.DENOMINATION_AMOUNT0_01	(vm_parameter::DENOMINATION_AMOUNT0_01)
				)

		vm_inst1(
					.i_clk						(dut_if.clk),
					.i_rst_n					(dut_if.rst),
					.i_money 					(vm_if.money),			
					.i_money_valid 				(vm_if.money_valid), 		
					.i_product_code 			(vm_if.product_code), 	
					.i_buy 						(vm_if.buy), 				
					.i_product_ready			(vm_if.product_ready),
					.o_product_code 			(vm_if.ready_product_code),		
					.o_product_valid			(vm_if.product_valid), 	
					.o_busy 					(vm_if.busy),		
					.o_change_denomination_code (vm_if.change_denomination_code),	
					.o_change_valid				(vm_if.change_valid),				
					.o_no_change				(vm_if.no_change) 				
				);

endmodule // dut_top

`endif // __DUT_TOP__
