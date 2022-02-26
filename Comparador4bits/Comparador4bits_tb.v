module Comparador4bits_tb();

reg[3:0] input1_reg, input2_reg;
wire[2:0] output_comparador_wire;

Comparador4bits test(

	.input1(input1_reg),
	.input2(input2_reg),
	.output_comparador(output_comparador_wire)
	
);

initial begin 

	input1_reg = 15;
	input2_reg = 0;
	#20
	
	input1_reg = 5;
	input2_reg = 5;
	#20
	
	input1_reg = 10;
	input2_reg = 15;
	#20
	
	input1_reg = 15;
	input2_reg = 30;
	#20
	
	input1_reg = 2;
	input2_reg = 2;
	#20
	
	$stop;
	
end


endmodule