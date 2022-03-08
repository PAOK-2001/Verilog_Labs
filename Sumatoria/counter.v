module counter(
	input clk, rst, hardReset, enable,
	output reg[6:0] count
);

/* Enfoque 1: */
always@(posedge clk or negedge rst)
begin 
	if(~rst)           count <= 7'b0000000;
	else if(hardReset) count <= 7'b0000000;
	else if(enable)    count <= count + 7'b0000001;
end

endmodule 
