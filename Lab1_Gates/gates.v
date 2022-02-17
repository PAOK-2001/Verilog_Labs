/* LAB 1 COMPUERTAS LOGICAS
Pablo Agustin Ortega Kral A00344664

Practica para aplicar compuertas basicas en Verilog, para ello, se define un circuito "gates" 
con dos entradas 
*/

module gates(
	input       a_in,
	input       b_in,
	output[7:0] z_out
);

assign z_out[0] = a_in & b_in; // AND
assign z_out[1] = a_in | b_in; // OR
assign z_out[2] = ~ a_in; // NOT
assign z_out[3] = a_in ^ b_in; //XOR
assign z_out[4] = ~ (a_in & b_in); // NAND
assign z_out[5] = ~(a_in | b_in); // NOR
assign z_out[6] = ~(a_in ^ b_in); // XNOR
assign z_out[7] = a_in; // YES

endmodule
