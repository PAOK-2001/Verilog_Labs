module ALU_Gumnut_tb();

reg  [7:0]  GPR_rs;
reg  [7:0]  GPR_r2;
reg  [17:0] IR;
wire [7:0]  ALU_result;
wire [7:0]  ALU_shift_result;

ALU_Gumnut UUT( 
	 .GPR_rs(GPR_rs),
	 .GPR_r2(GPR_r2),
	 .IR(IR),
	 
	 .ALU_result(ALU_result),
	 .ALU_shift_result(ALU_shift_result) 
	 );

initial begin
//-------- ARITMETIC ---------
	//Aritmetic functions from REG
	IR = 18'b111000000000000000; //add from reg, should return 10
	GPR_rs = 7;
	GPR_r2 = 3;
	#25;
	IR = 18'b111000000000000010; //sub from reg, should return 0
	GPR_rs = 3;
	GPR_r2 = 3;
	#25;
	
	//Inmediate artimetic
	IR = 18'b000000000000001010 ; // Inmediate add, should return 115
	GPR_rs = 105;
	#25;
	IR = 18'b001000000000001010 ; // Inmediate sub, should return 10
	GPR_rs = 20;
	#25;

//--------LOGIC ---------
	// AND
	IR = 18'b111000000000000100; // 3 and 3
	GPR_rs = 3;
	GPR_r2 = 3;
	#25;
	// OR
	IR = 18'b111000000000000101; // 5 or 5
	GPR_rs = 5;
	GPR_r2 = 5;
	#25;
	// XOR
	IR = 18'b111000000000000110; // 5 xor 5
	GPR_rs = 5;
	GPR_r2 = 5;
	#25;

$stop;
end

endmodule
