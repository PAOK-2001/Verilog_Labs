module Password(
	input clk, rst,
	input      [3:0]  enable,
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
parameter[3:0] pwd1 = 1;
parameter[3:0] pwd2 = 7;
parameter[3:0] pwd3 = 1;
parameter[3:0] pwd4 = 2;

reg[3:0] value1, value2, value3, value4;

always @(posedge clk or negedge rst)
begin
	if(~rst)
		current_state <= idle;
	else
		current_state <= next_state;
end

always @(current_state, enable)
begin
	admitted = 0;
	case(current_state)
		idle:
		begin
			statusIndicator[0] = 1;
			if(enable[0] == 1) 
			begin
				if(enteredPassword == pwd1) 
					begin
					next_state = k1;
					value1 = enteredPassword;
					end
				else next_state = idle;
			end
			else next_state = idle;
		end
		
		k1:
		begin
			statusIndicator[1] = 1;
			if(enable[1] == 1) 
			begin
				if(enteredPassword == pwd2) 
				begin
				next_state = k2;
				value2 = enteredPassword;
				end
				else next_state = idle;
			end
			else next_state = k1;			
		end
		
		k2:
		begin
			statusIndicator[2] = 1;
			if(enable[2] == 1) 
			begin
				if(enteredPassword == pwd3)
				begin
				next_state = k3;
				value3 = enteredPassword;
				end
				else next_state = idle;
			end
			else next_state = k2;	
		end
		
		k3:
		begin
			statusIndicator[3] = 1;
			if(enable[3] == 1) 
			begin
				if(enteredPassword == pwd4) 
				begin
				next_state = k4;
				value4 = enteredPassword;
				end
				else next_state = idle;
			end
			else next_state = k3;	
		end
		
		k4:
		begin
			statusIndicator[4] = 1;
			admitted = 1;
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