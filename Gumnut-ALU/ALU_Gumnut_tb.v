module ALU_Gumnut_tb();

reg  [7:0]  GPR_rs,
reg  [7:0]  GPR_r2,
reg  [17:0] IR,
wire [7:0]  ALU_result,
wire [7:0]  ALU_shift_result

ALU_Gumnut UUT( 
	 .GPR_rs(GPR_rs),
	 .GPR_r2(GPR_r2),
	 .IR(IR),
	 .ALU_result(ALU_result),
	 .ALU_shift_result(ALU_shift_result) 
	 );

initial begin
	IR = 18'b1110000000000000
	GPR_rs= 5;
	GPR_r2 5;
end
