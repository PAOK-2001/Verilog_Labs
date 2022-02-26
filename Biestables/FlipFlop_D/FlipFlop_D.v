module FlipFlop_D(

	input clk, D,
	input[1:0] SR,
	output reg q

);

parameter set = 1;

always @(posedge clk)
begin 
	if(SR[0] == 0)
	
		q <= 0;
	
	else if(SR[1] == 0)
	
		q <= set;
	
	else
	
		q <= D;

end

endmodule
