module debouncer(
	input button, clk,
	output reg button_state = 0,
	output button_down, button_up
);

reg button_sync0, button_sync1;

always@(posedge clk)
begin
	button_sync0 <= button;
end

always@(posedge clk)
begin
	button_sync1 <=  button_sync0;
end

reg[8:0] count;
wire idle = (button_state==button_sync1);
wire max  = &count;

always@(posedge clk)
begin
	if(idle)
		count = 0;
	else
		begin
		count = count + 8'b1;
		if(max)
			button_state = ~button_state;
		end
end
// Variables Auxiliares	
assign button_down = ~idle & max & ~button_state;
assign button_up   = ~idle & max & button_state;

endmodule

