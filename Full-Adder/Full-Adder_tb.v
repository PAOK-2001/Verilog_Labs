module Full_Adder_tb();

reg[1:0] bits_reg;
reg carryIn_reg;
wire result_wire, carryOut_wire;

Full_Adder test(
	.bits(bits_reg),
	.carryIn(carryIn_reg),
	.result(result_wire),
	.carryOut(carryOut_wire)

);

initial begin 
	bits_reg[0] = 0;
	bits_reg[1] = 0;
	carryIn_reg     = 0;
	#20
	bits_reg[0] = 0;
	bits_reg[1] = 1;
	carryIn_reg     = 0;
	#20
	bits_reg[0] = 1;
	bits_reg[1] = 0;
	carryIn_reg     = 0;
	#20
	bits_reg[0] = 1;
	bits_reg[1] = 1;
	carryIn_reg     = 0;
	#20
	
	bits_reg[0] = 0;
	bits_reg[1] = 0;
	carryIn_reg     = 1;
	#20
	bits_reg[0] = 0;
	bits_reg[1] = 1;
	carryIn_reg     = 1;
	#20
	bits_reg[0] = 1;
	bits_reg[1] = 0;
	carryIn_reg     = 1;
	#20
	bits_reg[0] = 1;
	bits_reg[1] = 1;
	carryIn_reg     = 1;
	#20
$stop;
end
endmodule