module clk_divider(
	input clk, rst,
	output reg clk_div
);

reg[31:0]  counter;
localparam target = 25000000;

always@(posedge clk or negedge rst)
begin
	if(!rst)
		counter <= 0;
	else if(counter == target-1)
		counter = 0;
	else
		counter = counter + 32'b1;
end

always@(posedge clk or negedge rst)
begin
	if(!rst)
		clk_div = 1'b0;
	else if(counter == target-1)
		clk_div = ~clk_div;
	else
		clk_div = clk_div;
end
endmodule
