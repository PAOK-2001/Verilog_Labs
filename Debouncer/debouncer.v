module debouncer(
	input button, clk
	output reg button_state, button_down, button_up
);

