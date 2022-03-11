module ALU_display(
	//entradas de la ALU
	input   [3:0] alu_in1, alu_in2,
	input   [1:0] alu_selector,
	input         alu_switch1, alu_switch2,
	
	output  [7:0] alu_out,
	
	output  [6:0] in1_units_display,
					  in1_decenas_display,
						  
					  in2_units_display,
					  in2_decenas_display,
						  
						out_unit_display,
						out_decenas_display,
						out_centenas_display					  
);

ALU unidad_aritmetica_logica(
	.num1(alu_in1), 
	.num2(alu_in2),
	.operationSelect(alu_selector),
	.shiftButton1(alu_switch1), 
	.shiftButton2(alu_switch2),
	.result(alu_out)

);

wire[3:0] in1_unit    = alu_in1 % 10;
wire[3:0] in1_decenas = alu_in1 / 10;

wire[3:0] in2_unit    = alu_in2 % 10;
wire[3:0] in2_decenas = alu_in2 / 10;

wire[3:0] out_unit     = alu_out      % 10;
wire[3:0] out_decenas  = (alu_out/10) % 10;
wire[3:0] out_centenas = alu_out      / 100;



BCD UNIDADES_ENTRADA1(
	.num(in1_unit),
	.display7Segment(in1_units_display)

);

BCD DECENAS_ENTRADA1(
	.num(in1_decenas),
	.display7Segment(in1_decenas_display)

);

BCD UNIDADES_ENTRADA2(
	.num(in2_unit),
	.display7Segment(in2_units_display)

);

BCD DECENAS_ENTRADA2(
	.num(in2_decenas),
	.display7Segment(in2_decenas_display)

);



BCD UNIDADES_SALIDA(
	.num(out_unit),
	.display7Segment(out_unit_display)


);

BCD DECENAS_SALIDA(
	.num(out_decenas),
	.display7Segment(out_decenas_display)


);

BCD CENTENAS_SALIDA(
	.num(out_centenas),
	.display7Segment(out_centenas_display)


);

endmodule
