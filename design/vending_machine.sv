/*
 *	File: vending_machine.sv
 *	
 *	This file contains design
 *
*/

module vending_machine (
							i_clk,
							i_rst_n,

							i_money,			// code of input denomination
							i_money_valid, 		// valid money code on i_money 

							i_product_code, 	// input product code that 
												// customer what to buy
							i_buy, 				// customer made a choice

							i_product_ready, 	// product is already done

							o_product_code,		// output product code  
							o_product_valid, 	// valid product code on o_product_code_output
							o_busy,				// fsm is busy and processing old order

							o_change_denomination_code,	// code of denomination of money change
							o_change_valid,				// valid code on o_change_denomination_code
							o_no_change 				// there is no change
						);

// available product
// product's codes
localparam ESPRESSO  = 1, 
		   AMERICANO = 2,
		   LATTE	 = 3,
		   TEA		 = 4,
		   MILK		 = 5,
		   CHOCOLATE = 6,
		   NUTS	     = 7,
		   SNICKERS  = 8;		

// product price

parameter  	PRICE_PROD_ONE   = 320, //ESPRESSO
			PRICE_PROD_TWO   = 350, //AMERICANO
			PRICE_PROD_THREE = 400, //LATTE
			PRICE_PROD_FOUR  = 420, //TEA
			PRICE_PROD_FIVE  = 450, //MILK
			PRICE_PROD_SIX   = 300, //CHOCOLATE
			PRICE_PROD_SEVEN = 900, //NUTS
			PRICE_PROD_EIGHT = 800; //SHICKERS

// denomination codes and its values

localparam	   DENOMINATION_CODE_500 = 1,  DENOMINATION_VALUE_500 = 50000,
			   DENOMINATION_CODE_200 = 2,  DENOMINATION_VALUE_200 = 20000,
			   DENOMINATION_CODE_100 = 3,  DENOMINATION_VALUE_100 = 10000,
			   DENOMINATION_CODE_50  = 4,  DENOMINATION_VALUE_50  = 5000,
			   DENOMINATION_CODE_20  = 5,  DENOMINATION_VALUE_20  = 2000,
			   DENOMINATION_CODE_10  = 6,  DENOMINATION_VALUE_10  = 1000,
			   DENOMINATION_CODE_5   = 7,  DENOMINATION_VALUE_5   = 500,
			   DENOMINATION_CODE_2   = 8,  DENOMINATION_VALUE_2   = 200,
			   DENOMINATION_CODE_1   = 9,  DENOMINATION_VALUE_1   = 100,
			   DENOMINATION_CODE0_50 = 10, DENOMINATION_VALUE_0_50 = 50, 
			   DENOMINATION_CODE0_25 = 11, DENOMINATION_VALUE_0_25 = 25,
			   DENOMINATION_CODE0_10 = 12, DENOMINATION_VALUE_0_10 = 10,
			   DENOMINATION_CODE0_05 = 13, DENOMINATION_VALUE_0_05 = 5,
			   DENOMINATION_CODE0_02 = 14, DENOMINATION_VALUE_0_02 = 2,
			   DENOMINATION_CODE0_01 = 15, DENOMINATION_VALUE_0_01 = 1;

// initial amount of each denomitation

parameter  DENOMINATION_AMOUNT_500 = 100,
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

// FSM states

localparam 		CHOOSE_PRODUCT 	= 	0,
				ENTER_MONEY		= 	1,
				GIVE_PRODUCT 	= 	2,
				GIVE_CHANGE 	= 	3;


input 				i_clk, i_rst_n;	// system clock and reset signals

input 		[3:0]	i_money; 
input 				i_money_valid;
input 		[3:0]	i_product_code; // input of product's code

input 				i_buy;
input 				i_product_ready;

output 	reg [3:0]	o_product_code;
output 	reg 		o_product_valid; 	// valid product code on o_product_code_output
output 	reg			o_busy;				// fsm is busy and processing old order

output 	reg	[3:0]	o_change_denomination_code;	// code of denomination of money change
output 	reg			o_change_valid;				// valid code on o_change_denomination_code
output 	reg 		o_no_change; 				// there is no change in VM

reg 		[1:0]		state, next_state;

reg 		[20:0]		wallet; 			// money amount that customer input into VM
reg			[20:0] 		product_price;		// price of product
reg signed 	[20:0] 		change;				// wallet - price 

reg		[15:0] 		denom_amount_500, 	// amount of each denominator
					denom_amount_200, 	
					denom_amount_100, 	
					denom_amount_50, 		
					denom_amount_20, 		
					denom_amount_10, 	
					denom_amount_5, 		
					denom_amount_2, 		
					denom_amount_1,	
					denom_amount0_50,		
					denom_amount0_25, 	
					denom_amount0_10,	
					denom_amount0_05, 	
					denom_amount0_02, 	
					denom_amount0_01;	

always @(posedge i_clk or negedge i_rst_n) begin : state_change_block
	if(!i_rst_n) begin : fsm_state_change_reset
		state <= CHOOSE_PRODUCT;
	end else begin : fsm_state_change_operation
		state <= next_state;
	end
end

always @(posedge i_clk or negedge i_rst_n) begin : fsm_output_logic_block
	if(!i_rst_n) begin : fsm_output_logic_reset

		wallet <= 0;
		product_price <= 0;
		change 	<= 0;
		denom_amount_500	<= 	DENOMINATION_AMOUNT_500;
		denom_amount_200	<= 	DENOMINATION_AMOUNT_200;
		denom_amount_100	<= 	DENOMINATION_AMOUNT_100; 	
		denom_amount_50 	<= 	DENOMINATION_AMOUNT_50;		
		denom_amount_20 	<= 	DENOMINATION_AMOUNT_20;
		denom_amount_10 	<= 	DENOMINATION_AMOUNT_10;
		denom_amount_5 		<= 	DENOMINATION_AMOUNT_5;
		denom_amount_2 		<= 	DENOMINATION_AMOUNT_2;
		denom_amount_1		<= 	DENOMINATION_AMOUNT_1;
		denom_amount0_50	<= 	DENOMINATION_AMOUNT0_50;	
		denom_amount0_25	<= 	DENOMINATION_AMOUNT0_25; 	
		denom_amount0_10	<= 	DENOMINATION_AMOUNT0_10;
		denom_amount0_05	<= 	DENOMINATION_AMOUNT0_05; 	
		denom_amount0_02	<= 	DENOMINATION_AMOUNT0_02; 	
		denom_amount0_01	<= 	DENOMINATION_AMOUNT0_01;

		o_product_code 				<= 0;
		o_product_valid 			<= 0;
		o_busy 						<= 0;
		o_change_denomination_code	<= 0;
		o_change_valid 				<= 0;
		o_no_change 				<= 0;

	end else begin : fsm_output_logic_operation

		o_product_valid 			<= 0;
		o_busy 						<= 0;
		o_change_denomination_code	<= 0;
		o_change_valid 				<= 0;
		o_no_change 				<= 0;

		case(state)
			CHOOSE_PRODUCT:
				begin : choose_product_state_operation
					o_product_code <= i_product_code;
					case(i_product_code)
						ESPRESSO: 	product_price <= PRICE_PROD_ONE;
			   			AMERICANO:	product_price <= PRICE_PROD_TWO;
			   			LATTE:		product_price <= PRICE_PROD_THREE;
			   			TEA:		product_price <= PRICE_PROD_FOUR;
			   			MILK:		product_price <= PRICE_PROD_FIVE;
			   			CHOCOLATE:	product_price <= PRICE_PROD_SIX;
			   			NUTS:		product_price <= PRICE_PROD_SEVEN;
			   			SNICKERS:	product_price <= PRICE_PROD_EIGHT; 	
		   			endcase // i_product_code
				end
			ENTER_MONEY:
				begin : enter_money_state_operation
					if (wallet < product_price) begin
						if(i_money_valid) begin
							case(i_money)
							   DENOMINATION_CODE_500: 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_500 ;
							   		denom_amount_500 	<= 	denom_amount_500 	+	1;
							   	end
				   			   DENOMINATION_CODE_200: 
				   			   	begin 
				   			   		wallet <= wallet + DENOMINATION_VALUE_200 ;
				   			   		denom_amount_200 	<= 	denom_amount_200 	+	1;
				   			   	end
							   DENOMINATION_CODE_100: 
							   	begin
							   		wallet <= wallet + DENOMINATION_VALUE_100 ;
							   		denom_amount_100 	<= 	denom_amount_100 	+	1;
							   	end
							   DENOMINATION_CODE_50 : 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_50  ;						   
							   		denom_amount_50 	<= 	denom_amount_50 	+	1;
							   	end
							   DENOMINATION_CODE_20 : 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_20  ;						   
							   		denom_amount_20 	<= 	denom_amount_20 	+	1;
							   	end
							   DENOMINATION_CODE_10 : 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_10  ;						   
							   		denom_amount_10 	<= 	denom_amount_10 	+	1;
							   	end
							   DENOMINATION_CODE_5  : 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_5   ;					   
							   		denom_amount_5 	<= 	denom_amount_5 	+	1;
							   	end
							   DENOMINATION_CODE_2  : 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_2   ;					   
							   		denom_amount_2 	<= 	denom_amount_2 	+	1;
							   	end
							   DENOMINATION_CODE_1  : 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_1   ;					   
							   		denom_amount_1 	<= 	denom_amount_1 	+	1;
							   	end
							   DENOMINATION_CODE0_50: 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_0_50;						   
							   		denom_amount0_50 	<= 	denom_amount0_50 	+	1;
							   	end
							   DENOMINATION_CODE0_25: 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_0_25;					   
							   		denom_amount0_25 	<= 	denom_amount0_25 	+	1;
							   	end
							   DENOMINATION_CODE0_10: 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_0_10;					   
							   		denom_amount0_10 	<= 	denom_amount0_10 	+	1;
							   	end
							   DENOMINATION_CODE0_05: 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_0_05;				   
							   		denom_amount0_05 	<= 	denom_amount0_05 	+	1;
							   	end
							   DENOMINATION_CODE0_02: 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_0_02;				   
							   		denom_amount0_02 	<= 	denom_amount0_02 	+	1;
							   	end
							   DENOMINATION_CODE0_01: 
							   	begin 
							   		wallet <= wallet + DENOMINATION_VALUE_0_01;		
							   		denom_amount0_01 	<= 	denom_amount0_01 	+	1;
							   	end
							endcase // i_money
						end
					end
 				end
			GIVE_PRODUCT:
				begin : give_product_state_operation
					change <= wallet - product_price;
					o_product_valid	<= 1;
					o_busy 			<= 1;
				end
			GIVE_CHANGE:
				begin : give_change_state_operation
					o_busy <= 1;
					wallet <= 0;
					case(1'b1)
						denom_amount_200!=0 & ((change - DENOMINATION_VALUE_200)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE_200;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_200;
								denom_amount_200 <= denom_amount_200 - 1;
							end
						denom_amount_100!=0 & ((change - DENOMINATION_VALUE_100)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE_100;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_100;
								denom_amount_100 <= denom_amount_100 - 1;
							end
						denom_amount_50!=0 & ((change - DENOMINATION_VALUE_50)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE_50;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_50;
								denom_amount_50 <= denom_amount_50 - 1;
							end
						((change - DENOMINATION_VALUE_20)>=0) & denom_amount_20!=0: 
							begin
								o_change_denomination_code <= DENOMINATION_CODE_20;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_20;
								denom_amount_20 <= denom_amount_20 - 1;
							end
						denom_amount_10!=0 & ((change - DENOMINATION_VALUE_10)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE_10;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_10;
								denom_amount_10 <= denom_amount_10 - 1;
							end
						denom_amount_5!=0 & ((change - DENOMINATION_VALUE_5)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE_5;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_5;
								denom_amount_5 <= denom_amount_5 - 1;
							end
						denom_amount_2!=0 & ((change - DENOMINATION_VALUE_2)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE_2;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_2;
								denom_amount_2 <= denom_amount_2 - 1;
							end
						denom_amount_1!=0 & ((change - DENOMINATION_VALUE_1)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE_1;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_1;
								denom_amount_1 <= denom_amount_1 - 1;
							end
						denom_amount0_50!=0 & ((change - DENOMINATION_VALUE_0_50)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE0_50;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_0_50;
								denom_amount0_50 <= denom_amount0_50 - 1;
							end
						denom_amount0_25!=0 & ((change - DENOMINATION_VALUE_0_25)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE0_25;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_0_25;
								denom_amount0_25 <= denom_amount0_25 - 1;
							end
						denom_amount0_10!=0 & ((change - DENOMINATION_VALUE_0_10)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE0_10;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_0_10;
								denom_amount0_10 <= denom_amount0_10 - 1;
							end
						denom_amount0_05!=0 & ((change - DENOMINATION_VALUE_0_05)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE0_05;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_0_05;
								denom_amount0_05 <= denom_amount0_05 - 1;
							end
						denom_amount0_02!=0 & ((change - DENOMINATION_VALUE_0_02)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE0_02;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_0_02;
								denom_amount0_02 <= denom_amount0_02 - 1;
							end
						denom_amount0_01!=0 & ((change - DENOMINATION_VALUE_0_01)>=0): 
							begin
								o_change_denomination_code <= DENOMINATION_CODE0_01;
								o_change_valid <= 1;
								change <= change - DENOMINATION_VALUE_0_01;
								denom_amount0_01 <= denom_amount0_01 - 1;
							end
						default: 
							begin
								o_change_valid 	<= 	1;
								o_no_change 	<=	1;
							end
					endcase // 1'b1
				end
		endcase // next_state	
	end
end

always @(*) begin : fsm_state_change_logic_block
	case(state)
		CHOOSE_PRODUCT:
			if(i_buy == 1'b1) begin
				next_state = ENTER_MONEY;
			end else begin 
				next_state = CHOOSE_PRODUCT;
			end
		ENTER_MONEY:
			if (wallet >= product_price) begin
				next_state = GIVE_PRODUCT;
			end	else begin
				next_state = ENTER_MONEY;
			end
		GIVE_PRODUCT:
			if(i_product_ready) begin
				next_state = GIVE_CHANGE;
			end
			else begin
				next_state = GIVE_PRODUCT;
			end 
		GIVE_CHANGE:
			if(o_no_change | change == 0)
				next_state = CHOOSE_PRODUCT;
			else
				next_state = GIVE_CHANGE;
		default:
				next_state = CHOOSE_PRODUCT;
	endcase
end

endmodule // vending_machine