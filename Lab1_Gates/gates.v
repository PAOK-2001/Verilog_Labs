/* LAB 1 COMPUERTAS LOGICAS

Practica para aplicar compuertas basicas en Verilog, para ello, se define un circuito "gates" 
con dos entradas 
*/
module gates(
	// Entradas
	input       a_in, b_in,
	// Salida de 8 bits
	output[7:0] z_out
);
assign z_out[0] = a_in & b_in; // AND LED_7
assign z_out[1] = a_in | b_in; // OR LED_6
assign z_out[2] = ~ a_in; // NOT LED_5 
assign z_out[3] = a_in ^ b_in; //XOR LED_4
assign z_out[4] = ~ (a_in & b_in); // NAND LED_3
assign z_out[5] = ~(a_in | b_in); // NOR LED_2
assign z_out[6] = ~(a_in ^ b_in); // XNOR LED_1
assign z_out[7] = a_in; // YES LED_0SS
endmodule

