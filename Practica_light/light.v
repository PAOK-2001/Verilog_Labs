// Codigo para controlador de laser
module light(
	//Entradas
	input x1,x2,
	//Salida
	output f
);
// logica para mandar un pulso de salida (F = x1 XOR x2)
assign f = (x1 && (!x2)) || ((!x1)&& x2);
endmodule
