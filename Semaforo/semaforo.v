module semaforo(
	input clk, rst,
	output reg green, yellow, red
);

parameter GO   = 2'b00,
			 WAIT = 2'b01,
			 STOP = 2'b10;

reg[1:0] current_state, next_state;

wire newClock;

wire[3:0] contadorGreen, contadorYellow, contadorRed;

reg enableGreen, enableYellow, enableRed;

reg resetGreen, resetYellow, resetRed;


clk_divider nuevoReloj(

	.clk(clk),
	.rst(rst),
	.clk_div(newClock)

);

counter contador1(
	
	.pb(newClock), 
	.rst(resetGreen), 
	.enable(enableGreen),
	.count(contadorGreen),
	
);

counter contador2(
	
	.pb(newClock), 
	.rst(resetYellow), 
	.enable(enableYellow),
	.count(contadorYellow),
	
);

counter contador3(
	
	.pb(newClock), 
	.rst(resetRed), 
	.enable(enableRed),
	.count(contadorRed),
	
);

always@(posedge newClock, negedge rst)
begin
	if(!rst)
	begin
		current_state <= GO;
	end
	else
		current_state <= next_state;
end

always@(current_state, contadorGreen, contadorYellow, contadorRed)
begin
	green  = 0;
	yellow = 0;
	red    = 0;
	enableGreen = 0;
	enableYellow = 0;
	enableRed = 0;
	resetGreen = 1;
	resetYellow = 1;
	resetRed = 1;
	case(current_state)
		GO:
		begin
			
			green = 1;
			if(contadorGreen >= 5) 
			begin 
				resetGreen = 0;
				next_state = WAIT;
			end
			else 
			begin
				enableGreen = 1;
				next_state = GO;
			end
		end
		WAIT:
		begin
			yellow = 1;
			if(contadorYellow >= 2)
			begin 
				resetYellow = 0;	
				next_state = STOP;
			end
			else
			begin
				enableYellow = 1;
				next_state = WAIT;
			end
		end
		STOP:
		begin
			red = 1;
			if(contadorRed >= 4) 
			begin 
				resetRed = 0;
				next_state = GO;
			end
			else 
			begin
				enableRed = 1;
				next_state = STOP;
			end
		end
	endcase
end

endmodule

