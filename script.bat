vlog -work work -novopt -sv design/vending_machine.sv 
vlog -work work -novopt -sv simulation/chcker.svh 
vlog -work work -novopt -sv simulation/dut_top.sv 
vlog -work work -novopt -sv simulation/env.sv 
vlog -work work -novopt -sv simulation/if.svh 
vlog -work work -novopt -sv simulation/scrbrd.svh 
vlog -work work -novopt -sv simulation/sequencer.svh
vlog -work work -novopt -sv simulation/testbench.sv
vlog -work work -novopt -sv simulation/vm_parameter.svh
vlog -work work -novopt -sv simulation/vm_uvc.svh
vsim -novopt -c work.tb