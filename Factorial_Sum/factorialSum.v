module factorialSum(
	input             clk, rst, start,
	input       [5:0] num,
	output reg  [1:0] statusLed,
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
wire  [9:0] counterOut; //out of counter
wire  [9:0] accum;
reg   [9:0] result;
wire reachedFlag;

//Asignment of displays
assign acc_units     = result % 10;
assign acc_tens      = (result / 10) % 10;
assign acc_hundreths = result / 100;

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
	.display7Segment(disp_unit)
);

BCD DECENAS(
	.num(acc_tens),
	.display7Segment(disp_tens)
);

BCD CENTENAS(
	.num(acc_hundreths),
	.display7Segment(disp_hundreth)
);

// State Machine
always@(posedge newClock, negedge rst) 
begin
	if(~rst) current_state <= idle;
	else current_state <= next_state;
end

// State change logic
always@(start, reachedFlag)
begin
	case(current_state)
		idle:
		begin
			if(start) next_state <= compute;
			else next_state      <= idle;
		end
		compute:
		begin
			if(reachedFlag) next_state <= done;
			else next_state <= compute;
		end
		done:
		begin
			if(start) next_state <= idle;
			else next_state <= done;
		end
	endcase
end

// Enable logic
always@(current_state)
begin
	case(current_state)
	idle:
	begin
		target       <= num;
		result       <= 0;
		accumEn      <= 0;
		statusLed[0] <= 0;
		statusLed[1] <= 0;
	end
	compute:
	begin
		accumEn      <= 1;
		statusLed[0] <= 1;
		result       <= accum;
	end
	done:
	begin
		accumEn      <= 0;
		statusLed[1] <= 1;
		
	end
	endcase
end


endmodule
