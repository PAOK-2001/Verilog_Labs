module accumulator(
	input            enable, clk,
	input      [5:0] target,
	output reg [5:0] count,
	output reg [9:0] accumulated,
	output reg maxReached
);

always@(posedge clk)
begin
	if(enable)
		begin
			if(count < target)
				begin
					maxReached  = 0;
					count       = count +1;
					accumulated = accumulated + count;
				end
			else 
			begin
				maxReached  = 1;
			end
		end
	else
	begin
		count       = 0;
		maxReached  = 0;
		accumulated = 0;
	end
end

endmodule
