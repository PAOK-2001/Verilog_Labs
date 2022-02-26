//Comparador de cadenas de 4 bits

module Comparador4bits(

	//declaracion de los vectores
	input[3:0] input1, input2,
	
	//salidas representando que operacion logica se cumple
	output reg [2:0] output_comparador

);

/*assign output_comparador[0] = input1 > input2;
assign output_comparador[1] = input1 == input2;
assign output_comparador[2] = input1 < input2;*/

always @*
begin 

	if (input1 > input2)
		
		//La operacion logica que se cumple es el mayor que
		output_comparador = 3'b001;
		
	else if (input1 == input2)
	
		//La operacion logica que se cumple es el igual que
		output_comparador = 3'b010;
		
	else 
	
		//La operacion logica que se cumple es el menor que
		output_comparador = 3'b100;
		
end

endmodule