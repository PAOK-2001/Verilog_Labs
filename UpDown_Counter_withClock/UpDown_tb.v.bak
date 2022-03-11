module UpDown_tb();

reg clk, clc, button, countSelect;
wire [6:0] display_unidades, display_decenas;

UpDown UUT(
	 .clk(clk), 
	 .clc(clc),
	 .button(button), 
	 .countSelect(countSelect),
	 .display_unidades(display_unidades), 
	 .display_decenas(display_decenas)
);

initial begin
	clk = 0;
	forever #25 clk = ~clk;
end

initial begin
	// clc pressed
	clc    = 0;
	button = 1;
	countSelect = 1;
	#50	
	// Button pressed, counting up
clc    = 1;
	button = 0;
	countSelect = 1;
	#25
	clc    = 1;
	button = 1;
	countSelect = 1;
	#25
	clc    = 1;
	button = 0;
	countSelect = 1;
	#25
	clc    = 1;
	button = 1;
	countSelect = 1;
	#25
	clc    = 1;
	button = 0;
	countSelect = 1;
	#25
	clc    = 1;
	button = 1;
	countSelect = 1;
	#25
	clc    = 1;
	button = 0;
	countSelect = 1;
	#25
	clc    = 1;
	button = 1;
	countSelect = 1;
	#25
	//Down
	clc    = 0;
	button = 1;
	countSelect = 0;
	#50
	clc    = 0;
	button = 0;
	countSelect = 0;
	clc    = 0;
	button = 1;
	countSelect = 0;
	#50
	clc    = 0;
	button = 0;
	countSelect = 0;
	clc    = 0;
	button = 1;
	countSelect = 0;
	#50
	clc    = 0;
	button = 0;
	countSelect = 0;
	$stop;
	
end



endmodule
