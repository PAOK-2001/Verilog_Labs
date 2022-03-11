transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Practicas/Verilog_Labs/UpDown_Counter {C:/Practicas/Verilog_Labs/UpDown_Counter/clk_divider.v}
vlog -vlog01compat -work work +incdir+C:/Practicas/Verilog_Labs/UpDown_Counter {C:/Practicas/Verilog_Labs/UpDown_Counter/counter.v}
vlog -vlog01compat -work work +incdir+C:/Practicas/Verilog_Labs/UpDown_Counter {C:/Practicas/Verilog_Labs/UpDown_Counter/UpDown.v}
vlog -vlog01compat -work work +incdir+C:/Practicas/Verilog_Labs/UpDown_Counter {C:/Practicas/Verilog_Labs/UpDown_Counter/BCD.v}
vlog -vlog01compat -work work +incdir+C:/Practicas/Verilog_Labs/UpDown_Counter {C:/Practicas/Verilog_Labs/UpDown_Counter/one_shot.v}

vlog -vlog01compat -work work +incdir+C:/Practicas/Verilog_Labs/UpDown_Counter {C:/Practicas/Verilog_Labs/UpDown_Counter/UpDown_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  UpDown_tb

add wave *
view structure
view signals
run -all
