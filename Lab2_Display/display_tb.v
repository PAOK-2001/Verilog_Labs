module display_tb();

reg[3:0] entryNum_reg;
wire[6:0] display_wire;

display test(
	.num(entryNum_reg),
	.display7Segment(display_wire)
);

initial begin
	entryNum_reg = 4'h0;
	#20
	entryNum_reg = 4'h1;
	#20
	entryNum_reg = 4'h2;
	#20
	entryNum_reg = 4'h3;
	#20
	entryNum_reg = 4'h4;
	#20
	entryNum_reg = 4'h5;
	#20
	entryNum_reg = 4'h6;
	#20
	entryNum_reg = 4'h7;
	#20
	entryNum_reg = 4'h8;
	#20
	entryNum_reg = 4'h9;
	#20
	entryNum_reg = 4'hA;
	#20
	entryNum_reg = 4'hB;
	#20
	entryNum_reg = 4'hC;
	#20
	entryNum_reg = 4'hD;
	#20
	entryNum_reg = 4'hE;
	#20
	entryNum_reg = 4'hF;
	#20
	$stop;
end

endmodule
