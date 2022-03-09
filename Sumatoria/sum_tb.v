module sum_tb();

reg       clk_reg, rst_reg, start_reg;
reg[5:0]  data_reg;

wire[10:0] accumulator_wire;

sum UUT(
	.clk(clk_reg), 
	.rst(rst_reg), 
	.start(start_reg),
	.data(data_reg),
	.accumulator(accumulator_wire)

);
endmodule
