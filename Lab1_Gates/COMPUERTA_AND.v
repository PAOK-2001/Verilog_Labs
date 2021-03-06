
module COMPUERTA_AND(
	// Entradas de un AND de 1 BIT
	input AND_IN_1,
	input AND_IN_2,
	// Entrada en forma de vector
	input[1:0] AND_IN,
	// Salida de AND de bit individuales
	output AND_OUT,
	// Salida de AND de entrada en forma de vector
	output reg AND_V_OUT
);

// Evaluacion de salida 
assign AND_OUT = AND_IN_1 & AND_IN_2;
// Evaluacion usando ALWAYS
always@(AND_IN)
begin
	AND_V_OUT = AND_IN[0] & AND_IN[1];
end
endmodule
