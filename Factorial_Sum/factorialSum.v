module factorialSum(
	input             clk, rst, start,
	input       [5:0] num,
	input       [1:0] statusLed,
	output wire [6:0] disp_unit,
	output wire [6:0] disp_tens,
	output wire [6:0] disp_hundreth
);

// States of FSM
parameter idle    = 0,
			 compute = 1,
			 done    = 2;
			 
reg [1:0] current_state; 
reg [1:0] next_state;

// Values for displays
wire [3:0] acc_units;
wire [3:0] acc_tens;
wire [3:0] acc_hundreths;

// Wire for new clock
wire newClock;

// Value to reach
reg  [5:0] target;

// Values to computate sums
reg accumEn;
wire [9:0] counterOut; //out of counter
wire  [9:0] accum;
wire reachedFlag;

//Asignment of displays
assign acc_units     = accum % 10;
assign acc_tens      = (accum / 10) % 10;
assign acc_hundreths = accum / 100;

// Intiatiation of modules
clk_divider New_Clock(
	.clk(clk), 
	.rst(rst),
	.clk_div(newClock)
);

accumulator PlsWork(
	.enable(accumEn), 
	.clk(newClock),
	.target(target),
	.count(counterOut),
	.accumulated(accum),
	.maxReached(reachedFlag)
);

BCD UNITS(
	.num(acc_units),
	.display7Segment(display_units)
);

BCD DECENAS(
	.num(acc_tens),
	.display7Segment(display_decenas)
);

BCD CENTENAS(
	.num(acc_hundreths),
	.display7Segment(display_centenas)
);

// State Machine
