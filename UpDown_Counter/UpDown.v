module UpDown(
	input clk, clc, button, countSelect,
	output[6:0] result, display
);

wire new_clock;
wire debounced_button;

clk_divider DIVIDER(
	.clk(clk),
	.rst(clc),
	.clk_div(new_clock)
);

debouncer DEBOUNCE(
	.button(button), 
	.clk(new_clock),
	.button_state(debounced_button)
);

counter COUNT(
	.pb(debounced_button),
	.rst(clc),
	.select(countSelect),
	.count(result)
);


BCD DISPLAY_RESULT(
	.num(result),
	.display7Segment(display)

);


endmodule

