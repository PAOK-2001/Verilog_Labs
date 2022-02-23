transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/paok/Documents/Verilog_Labs/Full-Adder {/home/paok/Documents/Verilog_Labs/Full-Adder/Full_Adder.v}

vlog -vlog01compat -work work +incdir+/home/paok/Documents/Verilog_Labs/Full-Adder {/home/paok/Documents/Verilog_Labs/Full-Adder/Full_Adder_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  Full_Adder_tb

add wave *
view structure
view signals
run -all
