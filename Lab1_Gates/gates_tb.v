
module gates_tb();

reg a_reg;
reg b_reg;

wire[7:0] z_wire;

gates dut(
	.a_in(a_reg),
	.b_in(b_reg),
	
	.z_out(z_wire)
);


initial begin
	a_reg = 1'b0;
	b_reg = 1'b0;
	#20
	a_reg = 1'b1;
	b_reg = 1'b0;
	#20
	a_reg = 1'b0;
	b_reg = 1'b1;
	#20
	a_reg = 1'b1;
	b_reg = 1'b1;
	#20
	
	$stop;
end
endmodule
