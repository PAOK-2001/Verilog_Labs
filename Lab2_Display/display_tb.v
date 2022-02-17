module display_tb();

reg[3:0] entryNum_reg;
wire[6:0] display_wire;

display test(
	.entryNum(entryNum_reg),
	.displaySegment(display_wire)
);

initial begin
	entryNum_reg = 3'h0;
	#20
	entryNum_reg = 3'h1;
	#20
	entryNum_reg = 3'h2;
	#20
	entryNum_reg = 3'h3;
	#20
	entryNum_reg = 3'h4;
	#20
	entryNum_reg = 3'h5;
	#20
	entryNum_reg = 3'h6;
	#20
	entryNum_reg = 3'h7;
	#20
	entryNum_reg = 3'h8;
	#20
	entryNum_reg = 3'h9;
	#20
	entryNum_reg = 3'hA;
	#20
	entryNum_reg = 3'hB;
	#20
	entryNum_reg = 3'hC;
	#20
	entryNum_reg = 3'hD;
	#20
	entryNum_reg = 3'hE;
	#20
	entryNum_reg = 3'hF;
	#20
	$stop;
end

endmodule
