module UpDown(
	input clk, clc, countSelect,
	output[6:0] display_unidades, display_decenas
);

wire[6:0] result;
wire new_clock;
wire debounced_button;

clk_divider DIVIDER(
	.clk(clk),
	.rst(clc),
	.clk_div(new_clock)
);

counter COUNT(
	.clk(new_clock),
	.rst(clc),
	.select(countSelect),
	.count(result)
);

wire[6:0] result_unidades;
assign result_unidades = result % 10;

wire[6:0] result_decenas = result / 10;

BCD DISPLAY_UNIDADES(
	.num(result_unidades),
	.display7Segment(display_unidades)
);

BCD DISPLAY_DECENAS(
	.num(result_decenas),
	.display7Segment(display_decenas)
);

endmodule

