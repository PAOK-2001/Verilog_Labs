module sum(
	input             clk, rst, start,
	input       [5:0] data,
	output reg  [1:0] status_indicator,
	output      [6:0] display_units, display_decenas, display_centenas

);

wire         clock;
reg  [10:0]  accumulator;
reg          hardReset, counterEnable;
reg  [5:0]   target;
wire [10:0]  iterations;
wire         counterMax;


reg[2:0] current_state, next_state;
parameter IDLE      = 0;
parameter START     = 1;
parameter COMPUTING = 2;
parameter DONE      = 3;

reg  [5:0]  units, decenas, centenas;


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
	.count(iterations),
	.counterMax(counterMax)
);


BCD UNITS(
	.num(units),
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


always@(posedge clock, negedge rst) 
begin
	if(~rst) current_state <= IDLE;
	else current_state <= next_state;
end

always@(current_state) 
begin
	status_indicator[0] <= 0;
	status_indicator[1] <= 0;
	counterEnable = 0;
	target = data;
	
	case(current_state)
		IDLE:
		begin
			status_indicator[0] <= 0;
			status_indicator[1] <= 0;
			if(start) next_state <= START;
			else      next_state <= IDLE;
		end
		
		START: 
		begin
			counterEnable = 0;
			hardReset     = 1;
			accumulator   <= 0;
			next_state    <= COMPUTING;
		end
		
		COMPUTING: 
		begin
			hardReset = 0;
			counterEnable = 1;
			status_indicator[0] = 1;
			if(counterMax) next_state   <= DONE;
			else 
			begin
				next_state <= COMPUTING;
			end
			accumulator  <= accumulator + iterations;
			
		end
		
		DONE:
		begin
			counterEnable = 0;
			status_indicator[1] <= 1;
			if(start)  next_state <= START;
			else       next_state <= DONE;
		end
		
		default:next_state <= IDLE;
		
	endcase 
	
	units    =  accumulator % 10;
	decenas  =  (accumulator/10) % 10;
	centenas =  accumulator / 100;
end


endmodule
