/*
 *	File: sequencer.svh
 *	
 *	This file contains description of sequencer
 *
*/

`ifndef __SEQUENCER_SVH__ 
`define __SEQUENCER_SVH__

`include "./simulation/if.svh"
`include "./simulation/vm_uvc.svh"
`include "./simulation/vm_parameter.svh"

import vm_parameter::*;

class sequencer;

	virtual dut_interface 		dut_if;
	virtual vm_in_interface 	vm_if;

	vm_transactor 			vm_transactor;

	function new(
					virtual dut_interface 		dut_if,
					virtual vm_in_interface 	vm_if
				);

		this.dut_if 	= 	dut_if;
		this.vm_if 		=	vm_if;

		vm_transactor	=	new(dut_if,vm_if);
	
	endfunction : new

	task send_product_without_change(int i);
		int 	product_price;
		int 	money_sequence[$:100];

		case(i)
			1:	product_price = vm_parameter::PRICE_PROD_ONE;
			2:	product_price = vm_parameter::PRICE_PROD_TWO;	   
			3:	product_price = vm_parameter::PRICE_PROD_THREE;
			4:	product_price = vm_parameter::PRICE_PROD_FOUR; 
			5:	product_price = vm_parameter::PRICE_PROD_FIVE; 
			6:	product_price = vm_parameter::PRICE_PROD_SIX;  
			7:	product_price = vm_parameter::PRICE_PROD_SEVEN;
			8:	product_price = vm_parameter::PRICE_PROD_EIGHT;
		endcase 

		while(product_price > 0) begin
			case(1'b1)
				(product_price - vm_parameter::DENOMINATION_VALUE_10 >=0):
					begin
						money_sequence = {money_sequence, vm_parameter::DENOMINATION_CODE_10};
						product_price  = product_price - vm_parameter::DENOMINATION_VALUE_10;
					end
				(product_price - vm_parameter::DENOMINATION_VALUE_5 >=0):
					begin
						money_sequence = {money_sequence, vm_parameter::DENOMINATION_CODE_5};
						product_price  = product_price - vm_parameter::DENOMINATION_VALUE_5;
					end
				(product_price - vm_parameter::DENOMINATION_VALUE_2 >=0):
					begin
						money_sequence = {money_sequence, vm_parameter::DENOMINATION_CODE_2};
						product_price  = product_price - vm_parameter::DENOMINATION_VALUE_2;
					end
				(product_price - vm_parameter::DENOMINATION_VALUE_1 >=0):
					begin
						money_sequence = {money_sequence, vm_parameter::DENOMINATION_CODE_1};
						product_price  = product_price - vm_parameter::DENOMINATION_VALUE_1;
					end
				(product_price - vm_parameter::DENOMINATION_VALUE_0_50 >=0):
					begin
						money_sequence = {money_sequence, vm_parameter::DENOMINATION_CODE0_50};
						product_price  = product_price - vm_parameter::DENOMINATION_VALUE_0_50;
					end
				(product_price - vm_parameter::DENOMINATION_VALUE_0_25 >=0):
					begin
						money_sequence = {money_sequence, vm_parameter::DENOMINATION_CODE0_25};
						product_price  = product_price - vm_parameter::DENOMINATION_VALUE_0_25;
					end
				(product_price - vm_parameter::DENOMINATION_VALUE_0_10 >=0):
					begin
						money_sequence = {money_sequence, vm_parameter::DENOMINATION_CODE0_10};
						product_price  = product_price - vm_parameter::DENOMINATION_VALUE_0_10;
					end
				(product_price - vm_parameter::DENOMINATION_VALUE_0_05 >=0):
					begin
						money_sequence = {money_sequence, vm_parameter::DENOMINATION_CODE0_05};
						product_price  = product_price - vm_parameter::DENOMINATION_VALUE_0_05;
					end
				(product_price - vm_parameter::DENOMINATION_VALUE_0_02 >=0):
					begin
						money_sequence = {money_sequence, vm_parameter::DENOMINATION_CODE0_02};
						product_price  = product_price - vm_parameter::DENOMINATION_VALUE_0_02;
					end
				(product_price - vm_parameter::DENOMINATION_VALUE_0_01 >=0):
					begin
						money_sequence = {money_sequence, vm_parameter::DENOMINATION_CODE0_01};
						product_price  = product_price - vm_parameter::DENOMINATION_VALUE_0_01;
					end
			endcase
		end

		vm_transactor.vm_non_randon_trn(money_sequence, i);
	endtask : send_product_without_change

	task run_test(int run_count = 1);
		int it = 1;

		$display("[%t][SEQ] Random Tests",$time());
		
		repeat (run_count) begin
			randsequence(main)
				main: rst_init test;
				test: repeat(8) product_without_change repeat(100000) random_product;
				rst_init: {};
				product_without_change: {
					send_product_without_change(it);
					it++;
				};
				random_product: {
					vm_transactor.vm_random_trn();
				};
			endsequence
		end
	endtask : run_test

endclass : sequencer

`endif //__SEQUENCER_SVH__
