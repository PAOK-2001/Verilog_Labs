transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Practicas/Verilog_Labs/UpDown_Counter_withClock {C:/Practicas/Verilog_Labs/UpDown_Counter_withClock/clk_divider.v}
vlog -vlog01compat -work work +incdir+C:/Practicas/Verilog_Labs/UpDown_Counter_withClock {C:/Practicas/Verilog_Labs/UpDown_Counter_withClock/counter.v}
vlog -vlog01compat -work work +incdir+C:/Practicas/Verilog_Labs/UpDown_Counter_withClock {C:/Practicas/Verilog_Labs/UpDown_Counter_withClock/UpDown.v}
vlog -vlog01compat -work work +incdir+C:/Practicas/Verilog_Labs/UpDown_Counter_withClock {C:/Practicas/Verilog_Labs/UpDown_Counter_withClock/BCD.v}

