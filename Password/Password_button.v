module Password_button(
	input             clk, rst,
	input             pb,
	input      [3:0]  enteredPassword,
	output reg        admitted,
	output     [6:0]  display1,display2,display3,display4,din,
	output reg [4:0]  statusIndicator
);

parameter	idle 	      = 0,
				k1 	      = 1,
				k2		      = 2,
				k3		      = 3,
				k4		      = 4;
						
reg[2:0] current_state, next_state;
parameter pwd1 = 4'd1;
parameter pwd2 = 4'd2;
parameter pwd3 = 4'd3;
parameter pwd4 = 4'd4;

parameter P = 10;
parameter A = 11;
parameter S = 5;

reg[6:0] value1 = 0;
reg[6:0] value2 = 0; 
reg[6:0] value3 = 0; 
reg[6:0] value4 = 0;

reg[3:0] counter = 0;

wire clock;
wire confirm;

clk_divider DIVIDER(
	.clk(clk),
	.rst(rst),
	.clk_div(clock)
);

one_shot DEBOUNCER(
	.button(pb), 
	.clk(clock),
	.button_state(confirm)
);


always @(posedge clock or negedge rst)
begin
	if(~rst)
		current_state <= idle;
	else
		current_state <= next_state;
end

always @(current_state, confirm)
begin
	admitted = 0;
	value1   = 0; 
	value2   = 0; 
	value3   = 0;
	value4   = 0;
	statusIndicator[0] = 0;
	statusIndicator[1] = 0;
	statusIndicator[2] = 0;
	statusIndicator[3] = 0;
	statusIndicator[4] = 0;
	case(current_state)
	idle:
		begin
			counter = 0;
			statusIndicator[0] = 1;
			if(confirm) 
			begin
				if(enteredPassword == pwd1) 
					begin
					next_state = k1;
					end
				else next_state = idle;
			end
			else next_state = idle;
		end
		
		k1:
		begin
			value1 = pwd1;
			statusIndicator[1] = 1;
			if(confirm) 
			begin
				if(enteredPassword == pwd2) 
				begin
				next_state = k2;
				end
				else next_state = idle;
			end
			else next_state = k1;			
		end
		
		k2:
		begin
			value1 = pwd1;
			value2 = pwd2;
			statusIndicator[2] = 1;
			if(confirm) 
			begin
				if(enteredPassword == pwd3)
				begin
				next_state = k3;
				end
				else next_state = idle;
			end
			else next_state = k2;	
		end
		
		k3:
		begin
			value1 = pwd1;
			value2 = pwd2;
			value3 = pwd3;
			value4 = enteredPassword;
			statusIndicator[3] = 1;
			if(confirm) 
			begin
				if(enteredPassword == pwd4) 
				begin
					next_state = k4;
				end
				else next_state = idle;
			end
			else next_state = k3;	
		end
		
		k4:
		begin
			counter = counter + 1;
			statusIndicator[4] = 1;
			admitted = 1;
			value1 = P;
			value2 = A;
			value3 = S;
			value4 = S;
			if(counter >= 4'd12) next_state = idle;
			else next_state = k4;
		end
		
		default:
		begin
			next_state = idle;
		end
	endcase
end

BCD DISPLAY_SET_1(
	.num(value1),
	.display7Segment(display1)
);

BCD DISPLAY_SET_2(
	.num(value2),
	.display7Segment(display2)
);

BCD DISPLAY_SET_3(
	.num(value3),
	.display7Segment(display3)
);

BCD DISPLAY_SET_4(
	.num(value4),
	.display7Segment(display4)
);

BCD DISPLAY_SET_IN(
	.num(enteredPassword),
	.display7Segment(din)
);

endmodule