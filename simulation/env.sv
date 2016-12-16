/*
 *	File: env.sv 
 *
 *	This file contains simulation environment
 *
 *
*/


`include "./simulation/scrbrd.svh"
`include "./simulation/sequencer.svh"

program environment(dut_interface dut_if, vm_in_interface vm_in_if, vm_out_interface vm_out_if);

	scoreboard 		sb;
	sequencer		sq;

	initial begin 
	
		sb 	=	new(	
						dut_if,
						vm_in_if,
						vm_out_if
					);

		sq 	=	new(
						dut_if,
						vm_in_if
					);

		$display("=======================================================");
    	$display("[%t][INFO] Simulation Environment Initialised",$time());

    	#1_000;

    	sq.run_test();

    	#1_000;

    end 

    final begin
    	$display("=======================================================");
    	$display("[%t][INFO] Simulation Environment Finished",$time());
    	sb.report_final_status();
    end

endprogram