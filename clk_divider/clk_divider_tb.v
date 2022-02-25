module clk_divider_tb();

reg clk_reg;
reg rst_reg;

wire clk_div_wire;

clk_divider uut(
	.clk(clk_reg),
	.rst(rst_reg),
	.clk_div(clk_div_wire)

);

initial begin
	clk_reg = 0;
	forever #10 clk_reg = ~clk_reg;
end

initial begin
	rst_reg = 1;
	#10
	rst_reg = 0;
	#1000
	$stop;
end
endmodule


