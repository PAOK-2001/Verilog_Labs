module sum(
	input             clk, rst, start,
	input       [5:0] data,
	output reg  [1:0] status_indicator,
	output reg  [10:0] accumulator,
	output      [6:0] display_units, display_decenas, display_centenas

);

wire        clock;
reg  [10:0] units, decenas, centenas;

reg         hardReset, counterEnable;
wire [5:0]  iterations;


reg[2:0] current_state, next_state;
parameter IDLE      = 0;
parameter START     = 1;
parameter COMPUTING = 2;
parameter DONE      = 3;

clk_divider New_Clock(
	.clk(clk), 
	.rst(rst),
	.clk_div(clock)
);

counter COUNT(
	.clk(clock), 
	.rst(rst), 
	.hardReset(hardReset), 
	.enable(counterEnable),
	.count(iterations)
);

always@(posedge clock, negedge rst) begin
	if(~rst) current_state <= IDLE;
	else current_state <= next_state;
end

always@(current_state, start) begin
	case(current_state)
		IDLE:
			if(start) next_state <= START;
			else      next_state <= IDLE;
		START: begin
			hardReset     <= 1;
			accumulator   <= 0;
			counterEnable <= 1;
			next_state    <= COMPUTING;
		end
		COMPUTING: begin
			status_indicator[0] = 1;
			if(iterations <= data) begin
				accumulator = accumulator + iterations;
				next_state  = COMPUTING;
			end
			else next_state = DONE;
		end
		DONE:
		begin
			status_indicator[1] = 1;
			units      <=  accumulator % 10;
			decenas    <=  (accumulator/10) % 10;
			centenas   <=  accumulator % 100;
			if(start)  next_state <= START;
			else       next_state <= DONE;
		end
	endcase 
end

BCD UNITS(
	.num(unit),
	.display7Segment(display_units)
);

BCD DECENAS(
	.num(decenas),
	.display7Segment(display_decenas)
);

BCD CENTENAS(
	.num(centenas),
	.display7Segment(display_centenas)
);

endmodule
