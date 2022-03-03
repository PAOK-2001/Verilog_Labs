module semaforo(
	input clk, rst,
	output reg green, yellow, red
);

wire clock;
wire maxReached;
reg[2:0] selector;
reg[1:0] current_state, next_state; 

parameter GO   = 2'b00,
			 WAIT = 2'b01,
			 STOP = 2'b10;

clk_divider newClock(
	.clk(clk), 
	.rst(rst),
	.clk_div(clock),
);

counter timeOut(
	.clk(clock), 
	.rst(rst),
	.select(selector),
	.maxReached(maxReached)
);
always@(posedge clock or negedge rst)
begin
	if(!rst)
	begin
		current_state <= GO;
	end
	else
		current_state <= next_state;
end

always@(current_state)
begin
	green  = 0;
	yellow = 0;
	red    = 0;
	
	selector[0] = 0;
	selector[1] = 0;
	selector[2] = 0;
	case(current_state)
		GO:
		begin
			selector[0] = 1;
			green = 1;
			if(maxReached) 
			begin
				//green = 0;
				next_state = WAIT;
			end
			else 
			begin
				next_state = GO;
			end
		end
		WAIT:
		begin
			selector[1] = 1;
			yellow = 1;
			if(maxReached)
			begin
				//yellow = 0;
				next_state = STOP;
			end
			else
			begin
				next_state = WAIT;
			end
		end
		STOP:
		begin
			selector[2] = 1;
			red = 1;
			if(maxReached) 
			begin 
				//red = 0;
				next_state = GO;
			end
			else 
			begin
				next_state = STOP;
			end
		end
	endcase
end

endmodule

