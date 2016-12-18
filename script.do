vlog -work work -novopt -sv simulation/chcker.svh 
vlog -work work -novopt -sv simulation/dut_top.sv 
vlog -work work -novopt -sv simulation/env.sv 
vlog -work work -novopt -sv simulation/if.svh 
vlog -work work -novopt -sv simulation/scrbrd.svh 
vlog -work work -novopt -sv simulation/sequencer.svh
vlog -work work -novopt -sv simulation/testbench.sv
vlog -work work -novopt -sv simulation/vm_parameter.svh
vlog -work work -novopt -sv simulation/vm_uvc.svh
vlog -work work -novopt -sv simulation/assertions.sv
vlog -work work -novopt -sv -coverExcludeDefault -nocoverfec -cover sbceft3 design/vending_machine.sv 
vsim -coverage work.tb
run -all
coverage report -file report.txt -source design/vending_machine.sv -assert -directive -cvg -codeAll
coverage report -detail -cvg -directive -config -comments -file fcover_report.txt -append -noa /testbench_sv_unit/scoreboard/cg_product /testbench_sv_unit/scoreboard/cg_money
quit -sim