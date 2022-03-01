module one_shot(
	input button, clk,
	output button_state
);
reg FlipFlop1;
reg FlipFlop2;

always@(posedge clk)
begin
	FlipFlop1 <= ~button;
	FlipFlop2 <= FlipFlop1;
end
assign button_state = ~button & ~FlipFlop2;
endmodule