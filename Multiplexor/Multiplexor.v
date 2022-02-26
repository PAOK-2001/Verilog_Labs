//Codigo de un multiplexor de 2 a 1

module Multiplexor(
	
	//Entradas de valores del multiplexor
	input[1:0] entradas,
	
	//Entrada de seleccion de multiplexor
	input seleccion,
	
	//Salida del multiplexor
	output reg salida
);

always@*
begin
	
	if (seleccion == 1)
	
		//La salida sera lo que este en la entrada con posicion 1
		salida = entradas[1];	
	
	else
	
		//La salida sera lo que este en la entrada con posicion 0
		salida = entradas[0];
		
end 
endmodule