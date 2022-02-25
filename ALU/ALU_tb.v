module ALU_tb();

reg  [3:0] num1_reg, num2_reg;
reg  [1:0] operationSelect_reg;
reg  shiftButton1_reg, shiftButton2_reg;
wire [7:0] result_wire;


ALU uut(

	.num1(num1_reg),
	.num2(num2_reg),
	.operationSelect(operationSelect_reg),
	.shiftButton1(shiftButton1_reg), 
	.shiftButton2(shiftButton2_reg),
	.result(result_wire)

);

initial begin
	num1_reg = 4'b1010;
	num2_reg = 4'b0101;
	shiftButton1_reg = 0;
	shiftButton2_reg = 0;
	operationSelect_reg = 2'b00;
	#10
	
	num1_reg = 4'b1010;
	num2_reg = 4'b0101;
	shiftButton1_reg = 0;
	shiftButton2_reg = 0;
	operationSelect_reg = 2'b01;
	#10
	
	num1_reg = 4'b1010;
	num2_reg = 4'b0101;
	shiftButton1_reg = 0;
	shiftButton2_reg = 0;
	operationSelect_reg = 2'b10;
	#10
	
	num1_reg = 4'b1010;
	num2_reg = 4'b0101;
	shiftButton1_reg = 0;
	shiftButton2_reg = 0;
	operationSelect_reg = 2'b11;
	#10
	
	num1_reg = 4'b1010;
	num2_reg = 4'b0101;
	shiftButton1_reg = 1;
	shiftButton2_reg = 0;
	operationSelect_reg = 2'b10;
	#10
	
	num1_reg = 4'b1010;
	num2_reg = 4'b0101;
	shiftButton1_reg = 0;
	shiftButton2_reg = 1;
	operationSelect_reg = 2'b01;
	#10
	
	num1_reg = 4'b1010;
	num2_reg = 4'b0101;
	shiftButton1_reg = 1;
	shiftButton2_reg = 1;
	operationSelect_reg = 2'b11;
	#10
	$stop;
end

endmodule
