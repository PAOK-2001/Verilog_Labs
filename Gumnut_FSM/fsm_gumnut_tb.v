module fsm_gumnut_tb();

reg clk_i;
reg rst_i;
reg[17:0] IR;
reg int_req; // Interrupt request
reg int_en;  // Interrupt enable
reg inst_ack_i; //Enable for decode
reg data_ack_i; //Enable for data entry
reg port_ack_i; // Enable for IO entry
wire [2:0] state;   // FSM state

fsm_gumnut UUT(
	 .clk_i(clk_i),  // Clock
    .rst_i(rst_i),  // Reset
	 .IR(IR),     // Instruction Register
	 // Interrupts
    .int_req(int_req), // Interrupt request
	 .int_en(int_en),  // Interrupt enable
	 .inst_ack_i(inst_ack_i), //Enable for decode
	 .data_ack_i(data_ack_i), //Enable for data entry
	 .port_ack_i(port_ack_i), // Enable for IO entry
	 .state(state)   // FSM state
);

initial begin
	clk_i = 0;
	forever #5 clk_i = ~clk_i;
end

initial begin
	rst_i = 1;
	#20
	//Artimetic operations
	rst_i      = 0;
	inst_ack_i = 1;
	int_en     = 0;
	int_req    = 0;
	data_ack_i = 0;
	port_ack_i = 0;
	IR         = 18'b111000000000000001;
	#100
	rst_i = 1;
	#20
	// Memory operations, but with DATA UNABLE. Should stay in mem_state
	rst_i      = 0;
	inst_ack_i = 1;
	int_en     = 0;
	int_req    = 0;
	data_ack_i = 0;
	port_ack_i = 0;
	IR         = 18'b100000100000000000;
	#100
	// ENABLE DATA
	data_ack_i = 1;
	port_ack_i = 1;
	#50
	$stop;
end


endmodule
