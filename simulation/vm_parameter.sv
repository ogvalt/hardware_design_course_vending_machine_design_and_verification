/*
 *	File: vm_parameter.sv
 *	
 *	This file contains parameter of vending machine
 *	that you can customize by you own, such as price of 
 *	each product and initial amount of each denomination.
 *
*/

`ifndef __VM_PARAM__
`define __VM_PARAM__

package vm_parameter;

	// prices of products
	parameter  	PRICE_PROD_ONE   = 320, //ESPRESSO
				PRICE_PROD_TWO   = 350, //AMERICANO
				PRICE_PROD_THREE = 400, //LATTE
				PRICE_PROD_FOUR  = 420, //TEA
				PRICE_PROD_FIVE  = 450, //MILK
				PRICE_PROD_SIX   = 300, //CHOCOLATE
				PRICE_PROD_SEVEN = 900, //NUTS
				PRICE_PROD_EIGHT = 800; //SHICKERS

	// initial amount of each denomination

	parameter  	DENOMINATION_AMOUNT_500 = 100,
		   		DENOMINATION_AMOUNT_200 = 100,
		   		DENOMINATION_AMOUNT_100 = 100,
		   		DENOMINATION_AMOUNT_50  = 100,
		   		DENOMINATION_AMOUNT_20  = 100,
		   		DENOMINATION_AMOUNT_10  = 100,
		   		DENOMINATION_AMOUNT_5   = 100,
		   		DENOMINATION_AMOUNT_2   = 100,
		   		DENOMINATION_AMOUNT_1   = 100,
		   		DENOMINATION_AMOUNT0_50 = 100,
		   		DENOMINATION_AMOUNT0_25 = 100,
		   		DENOMINATION_AMOUNT0_10 = 100,
		   		DENOMINATION_AMOUNT0_05 = 100,
		   		DENOMINATION_AMOUNT0_02 = 100,
		   		DENOMINATION_AMOUNT0_01 = 100;

endpackage

`endif //__VM_PARAM__