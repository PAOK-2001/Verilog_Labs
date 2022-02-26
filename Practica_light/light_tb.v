module light_tb();

reg x1,x2;
wire f;

light test(x1, x2, f);

initial begin

	x1 = 0;
	x2 = 0;
	#10;
	
	x1 = 0;
	x2 = 1;
	#10;
	
	x1 = 1;
	x2 = 0;
	#10;
	
	x1 = 1;
	x2 = 1;
	#10;
	

end

endmodule
