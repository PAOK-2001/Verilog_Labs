module debouncer_tb();
 // Inputs
 reg button_reg;
 reg clk_reg;
 // Outputs
 wire button_state_wire;
debouncer uut (
	.button(button_reg),
	.clk(clk_reg), 
	.button_state(button_state_wire)

 );
 initial begin
 
	clk_reg = 0;
	forever #10 clk_reg = ~clk_reg;
	
end
	
initial begin
	button_reg = 0;
	#10;
	button_reg=1;
	#20;
	button_reg = 0;
	#10;
	button_reg=1;
	#30; 
	button_reg = 0;
	#10;
	button_reg=1;
	#40;
	button_reg = 0;
	#10;
	button_reg=1;
	#30; 
	button_reg = 0;
	#10;
	button_reg=1; 
	#1000; 
	button_reg = 0;
	#10;
	button_reg=1;
	#20;
	button_reg = 0;
	#10;
	button_reg=1;
	#30; 
	button_reg = 0;
	#10;
	button_reg=1;
	#40;
	button_reg = 0; 
	#100000
	button_reg = 1; 
	#100000
	button_reg = 0; 
	#100000
	button_reg = 1; 
	#100000
	$stop;
end       
endmodule
