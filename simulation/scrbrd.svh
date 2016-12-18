/*
 *	File: scrbrd.svh  
 *	
 *	This file contains description of scoreboard class
 *
*/


`ifndef __SCOREBOARD_SVH__
`define __SCOREBOARD_SVH__

`include "./simulation/if.svh"
`include "./simulation/vm_uvc.svh"
`include "./simulation/chcker.svh"

class scoreboard;

	virtual 	dut_interface 		dut_if;
	virtual		vm_in_interface 	vm_in_if;
	virtual		vm_out_interface	vm_out_if;

	vm_checker 	vm_checker;

	covergroup cg_product @(dut_if.clk);
    	option.per_instance = 1; 
    	option.name = "cg_product";

    	coverpoint vm_in_if.product_code iff(dut_if.rst) {	
    		bins pr_one 	= {1};
    		bins pr_two 	= {2};
    		bins pr_three 	= {3};
    		bins pr_four 	= {4};
    		bins pr_five 	= {5};
    		bins pr_six 	= {6};
    		bins pr_seven 	= {7};
    		bins pr_eight 	= {8}; 
    		}

    	coverpoint vm_out_if.ready_product_code iff(dut_if.rst){ 
    		bins pr_one 	= {1};
    		bins pr_two 	= {2};
    		bins pr_three 	= {3};
    		bins pr_four 	= {4};
    		bins pr_five 	= {5};
    		bins pr_six 	= {6};
    		bins pr_seven 	= {7};
    		bins pr_eight 	= {8};
    		}

  	endgroup : cg_product

  	covergroup cg_money @(dut_if.clk);
  		option.per_instance = 1;
  		option.name = "cg_money";

  		coverpoint vm_in_if.money iff(dut_if.rst){ 
  			bins mn_one 	= {1};
    		bins mn_two 	= {2};
    		bins mn_three 	= {3};
    		bins mn_four 	= {4};
    		bins mn_five 	= {5};
    		bins mn_six 	= {6};
    		bins mn_seven 	= {7};
    		bins mn_eight 	= {8};
    		bins mn_nine 	= {9};
    		bins mn_ten 	= {10};
    		bins mn_eleven 	= {11};
    		bins mn_twelve 	= {12};
    		bins mn_thirteen= {13};
    		bins mn_fourteen= {14};
    		bins mn_fifteen	= {15};
    	}

    	coverpoint vm_out_if.change_denomination_code iff(dut_if.rst){ 
    		bins mn_two 	= {2};
    		bins mn_three 	= {3};
    		bins mn_four 	= {4};
    		bins mn_five 	= {5};
    		bins mn_six 	= {6};
    		bins mn_seven 	= {7};
    		bins mn_eight 	= {8};
    		bins mn_nine 	= {9};
    		bins mn_ten 	= {10};
    		bins mn_eleven 	= {11};
    		bins mn_twelve 	= {12};
    		bins mn_thirteen= {13};
    		bins mn_fourteen= {14};
    		bins mn_fifteen	= {15};
    	}

  	endgroup : cg_money

	function new(
					virtual dut_interface		dut_if,
					virtual vm_in_interface 	vm_in_if,
					virtual vm_out_interface 	vm_out_if
				);

		this.dut_if 	=	dut_if;
		this.vm_in_if 	=	vm_in_if;
		this.vm_out_if 	=	vm_out_if;

		vm_checker 		= 	new(
									dut_if,
									vm_in_if,
									vm_out_if
								);
		cg_product = new();
		cg_product.start();

		cg_money = new();
		cg_money.start();

	endfunction : new

	function void report_final_status();
		
		$display("=======================================================\nFINAL REPORT");
		$display("\terr_cnt = %-d\n\terr_change = %-d\n\terr_product = %-d", 
					checkr_comm::err_cnt, checkr_comm::err_change, checkr_comm::err_product);
		$display("\tpass_cnt = %-d\n\tpass_change = %-d\n\tpass_product = %-d", 
					checkr_comm::pass_cnt, checkr_comm::pass_change, checkr_comm::pass_product);
		$display("\t%s\n\tFunctional Coverage : %.1f%%", 			
             		(checkr_comm::err_cnt)?("FAIL"):("PASS"), $get_coverage());

	endfunction : report_final_status 

endclass : scoreboard
`endif //__SCOREBOARD_SVH__
