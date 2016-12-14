/*
 *	File: dut_top.sv
 *	
 *	Top level module of design
 *
*/

`ifndef	__DUT_TOP__
`define __DUT_TOP__

`include "./design/vending_machine.sv"
`include "./simulation/vm_parameter.svh"
`include "./simulation/if.svh"

`define CLOCK_PERIOD 2

import vm_parameter::*;

module dut_top 	(
					dut_interface 		dut_if,
					vm_in_interface 	vm_in_if,
					vm_out_interface 	vm_out_if
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

					.i_money 					(vm_in_if.money),			
					.i_money_valid 				(vm_in_if.money_valid), 		
					.i_product_code 			(vm_in_if.product_code), 	
					.i_buy 						(vm_in_if.buy), 				
					.i_product_ready			(vm_in_if.product_ready),

					.o_product_code 			(vm_out_if.ready_product_code),		
					.o_product_valid			(vm_out_if.product_valid), 	
					.o_busy 					(vm_out_if.busy),		
					.o_change_denomination_code (vm_out_if.change_denomination_code),	
					.o_change_valid				(vm_out_if.change_valid),				
					.o_no_change				(vm_out_if.no_change) 				
				);


		initial begin
			dut_if.rst = 0;
			#40;
			dut_if.rst = 1;
		end

		initial begin
			dut_if.clk = 0;
			@(posedge dut_if.rst);
			#20;
			forever #(`CLOCK_PERIOD) dut_if.clk = ~dut_if.clk;
		end

endmodule // dut_top

`endif // __DUT_TOP__
