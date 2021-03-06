module FlipFlop_tb();

reg D_reg, clk_reg, rst_reg;

wire Q_wire, Q_negada_wire;

FlipFlop test(

	.D(D_reg),
	.clk(clk_reg),
	.rst(rst_reg),
	.Q(Q_wire),
	.Q_negada(Q_negada_wire)
	
);

initial begin

	clk_reg = 1;
	forever #5 clk_reg = ~clk_reg;

end

initial begin

	D_reg = 0;
	rst_reg = 1;
	#10
	
	D_reg = 0;
	rst_reg = 0;
	#10
	
	D_reg = 1;
	rst_reg = 0;
	#10
	
	D_reg = 1;
	rst_reg = 1;
	#10
	
	D_reg = 0;
	rst_reg = 1;
	#10
	
$stop;
	
end

endmodule
