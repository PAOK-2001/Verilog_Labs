module Multiplexor(
	input[1:0] entradas,
	input seleccion,
	output reg salida
);

always@*
begin
	if (seleccion == 1)
		salida = entradas[1];	
	else
		salida = entradas[0];
		
end 
endmodule