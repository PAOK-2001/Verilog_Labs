module Comparador4bits(

	input[3:0] input1, input2,
	
	output reg [2:0] output_comparador

);

/*assign output_comparador[0] = input1 > input2;
assign output_comparador[1] = input1 == input2;
assign output_comparador[2] = input1 < input2;*/

always @*
begin 

	if (input1 > input2)
		output_comparador = 3'b001;
		
	else if (input1 == input2)
		output_comparador = 3'b010;
		
	else 
		output_comparador = 3'b100;
		
end

endmodule