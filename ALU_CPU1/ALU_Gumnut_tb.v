module ALU_Gumnut_tb();

reg  [7:0]  GPR_rs;
reg  [7:0]  GPR_r2;
reg  [17:0] IR;
wire [7:0]  ALU_result;
wire [7:0]  ALU_shift_result;

ALU_Gumnut test( 

	 .GPR_rs(GPR_rs),
	 .GPR_r2(GPR_r2),
	 .IR(IR),
	 
	 .ALU_result(ALU_result)
	 
);

initial begin

	IR = 18'b111000000000000000; 
	GPR_rs = 5;
	GPR_r2 = 5;
	#10;
	
	IR = 18'b111000000000000010; 
	GPR_rs = 5;
	GPR_r2 = 5;
	#10;
	
	IR = 18'b111000000000000000; 
	GPR_rs = 125;
	GPR_r2 = 25;
	#10;
	
	IR = 18'b111000000000000001; 
	GPR_rs = 3;
	GPR_r2 = 2;
	#10;
	
	IR = 18'b111000000000000000; 
	GPR_rs = 125;
	GPR_r2 = 25;
	#10;
	
	IR = 18'b111000000000000011; 
	GPR_rs = 4;
	GPR_r2 = 1;
	#10;
	
	IR = 18'b000000000000001010 ;
	GPR_rs = 125;
	#10;
	
	IR = 18'b001000000000001010 ; 
	GPR_rs = 125;
	#10;

$stop;
end

endmodule
