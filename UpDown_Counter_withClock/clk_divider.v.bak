module clk_divider(
	input clk, rst,
	output reg clk_div
);

reg[31:0]  counter;
localparam target = 5;
reg        enable = 0;

always@(posedge clk or posedge rst)
begin
	if(rst==1'b1)
		counter <= 0;
	else if(counter == target-1)
		counter = 0;
	else
		counter = counter +32'b1;
end

always@(*)
begin
	if(rst == 1'b1)
		clk_div = 1'b10;
	else if(counter == target-1)
		clk_div = ~clk_div;
	else
		clk_div = clk_div;
end
endmodule
