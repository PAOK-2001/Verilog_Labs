module ALU_tb();

	reg   [3:0] alu_in1, alu_in2;
	reg   [1:0] alu_selector;
	reg         alu_switch1, alu_switch2;
	
	wire  [7:0] alu_out;
	
	wire  [6:0] in1_units_display,
					in1_decenas_display,
						  
					in2_units_display,
					in2_decenas_display,
						  
					out_unit_display,
					out_decenas_display,
					out_centenas_display;


ALU_display uut(

	.alu_in1(alu_in1), 
	.alu_in2(alu_in2),
	.alu_selector(alu_selector),
	.alu_switch1(alu_switch1),
	.alu_switch2(alu_switch2),
	
	.alu_out(alu_out),
	
	.in1_units_display(in1_units_display),
	.in1_decenas_display(in1_decenas_display),
						  
	.in2_units_display(in2_units_display),
	.in2_decenas_display(in2_decenas_display),
						  
	.out_unit_display(out_unit_display),
	.out_decenas_display(out_decenas_display),
	.out_centenas_display(out_centenas_display)	

);

initial begin
	alu_in1 = 4'b1010;
	alu_in2 = 4'b0101;
	alu_switch1 = 0;
	alu_switch2 = 0;
	alu_selector = 2'b00;
	#10
	
	alu_in1 = 4'b1010;
	alu_in2 = 4'b0101;
	alu_switch1 = 0;
	alu_switch2 = 0;
	alu_selector = 2'b01;
	#10
	
	alu_in1 = 4'b1010;
	alu_in2 = 4'b0101;
	alu_switch1 = 0;
	alu_switch2 = 0;
	alu_selector = 2'b10;
	#10
	
	alu_in1 = 4'b1010;
	alu_in2 = 4'b0101;
	alu_switch1 = 0;
	alu_switch2 = 0;
	alu_selector = 2'b11;
	#10
	
	alu_in1 = 4'b1010;
	alu_in2 = 4'b0101;
	alu_switch1 = 1;
	alu_switch2 = 0;
	alu_selector = 2'b01;
	#10
	
	alu_in1 = 4'b1010;
	alu_in2 = 4'b0101;
	alu_switch1 = 0;
	alu_switch2 = 1;
	alu_selector = 2'b01;
	#10
	
	alu_in1 = 4'b1010;
	alu_in2 = 4'b0101;
	alu_switch1 = 1;
	alu_switch2 = 1;
	alu_selector = 2'b01;
	#10
	$stop;
end

endmodule
