module ALU_CPU_tb();

reg clk_i;
reg rst_i;
reg inst_ack_i;
reg [17:0] IR;
reg int_req;
reg int_en;
reg data_ack_i;
reg port_ack_i;
wire [2:0] state_out, next_state_out;

ALU_CPU test(

	.clk_i(clk_i),
	.rst_i(rst_i),
	.inst_ack_i(inst_ack_i),
	.IR(IR),
	.int_req(int_req),
	.int_en(int_en),
	.data_ack_i(data_ack_i),
	.port_ack_i(port_ack_i),
	.state_out(state_out),
	.next_state_out(next_state_out)
	
);

initial begin 

	clk_i = 0;
	forever #10 clk_i = ~clk_i;
	
end

initial begin 

	rst_i = 1;
	#5
	
	rst_i = 0;
	inst_ack_i = 1;
	IR = 18'b111000000010001100;
	int_req = 1;
	int_en = 1;
	data_ack_i = 1;
	port_ack_i = 1;
	#100
	
	$stop;

end

endmodule
