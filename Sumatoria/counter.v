module counter(
	input clk, rst, hardReset, enable, target,
	output reg counterMax,
	output reg [10:0] count
);

/* Enfoque 1: */
always@(posedge clk or negedge rst)
begin 
	if(~rst)
	begin
		count <= 0;
		counterMax <= 0;
	end
	else if(hardReset)
	begin
		count <= 0;
		counterMax <= 0;
	end
	else if(enable)
	begin
		count <= count + 1;
		counterMax <= 0;
		if(count > target) counterMax <= 1;	
	end
end

endmodule 
