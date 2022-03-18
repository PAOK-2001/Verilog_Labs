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
	 
	 .ALU_result(ALU_result)
	 //.ALU_shift_result(ALU_shift_result) 
	 );

initial begin
//-------- ARITMETIC ---------
	//Aritmetic functions from REG
	IR = 18'b111000000000000000; //add from reg, should return 10
	GPR_rs = 5;
	GPR_r2 = 5;
	#25;
	IR = 18'b111000000000000010; //sub from reg, should return 0
	GPR_rs = 5;
	GPR_r2 = 5;
	#25;
	
	//Artimetic funtions with carry from REG
	IR = 18'b111000000000000000; //add from reg, should have carry out
	GPR_rs = 125;
	GPR_r2 =25;
	#25;
	IR = 18'b111000000000000001; //addc from reg, should return 6 bc of cc_C
	GPR_rs = 3;
	GPR_r2 = 2;
	#25;
	IR = 18'b111000000000000000; //add from reg, should have carry out
	GPR_rs = 125;
	GPR_r2 =25;
	#25;
	IR = 18'b111000000000000011; //subc from reg, should return 3 bc of cc_C
	GPR_rs = 4;
	GPR_r2 = 1;
	#25;
	
	//Inmediate artimetic
	IR = 18'b000000000000001010 ; // Inmediate add, should return 135
	GPR_rs = 125;
	#25;
	IR = 18'b001000000000001010 ; // Inmediate sub, should return 115
	GPR_rs = 125;
	#25;
	
	
//--------LOGIC ---------
	// Logic functions from REG
	
//--------SHIFT ---------
//--------MEMORY ---------


$stop;
end

endmodule
