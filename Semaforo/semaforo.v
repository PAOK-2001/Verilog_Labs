module sema(
	input clk, rst, counter_green, counter_yellow, counter_red,
	output reg green, yellow, red
);

parameter GO   = 2'b00,
			 WAIT = 2'b01,
			 STOP = 2'b10;

reg[1:0] current_state, next_state;

always@(posedge clk, negedge rst)
begin
	if(!rst)
		current_state <= GO;
	else
		current_state <= next_state;
end

always@(current_state,counter_green, counter_yellow, counter_red)
begin
	green  = 0;
	yellow = 0;
	red    = 0;
	case(current_state)
		GO:
			begin
			green = 1;
			if(counter_green) next_state = WAIT;
			end
		WAIT:
			begin
			yellow = 1;
			if(counter_yellow) next_state = STOP;
			end
		STOP:
			begin
			red = 1;
			if(counter_red) next_state = GO;
			end
	endcase
end
endmodule

