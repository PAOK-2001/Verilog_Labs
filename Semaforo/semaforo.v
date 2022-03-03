module semaforo(
	input clk, rst,
	output reg green, yellow, red
);

parameter GO   = 2'b00,
			 WAIT = 2'b01,
			 STOP = 2'b10;

reg[1:0] current_state, next_state;

wire newClock;

reg[3:0] contador;

clk_divider nuevoReloj(

	.clk(clk),
	.rst(rst),
	.clk_div(newClock)

);

always@(posedge newClock, negedge rst)
begin
	if(!rst)
		current_state <= GO;
	else
		current_state <= next_state;
end

always@(current_state)
begin
	green  = 0;
	yellow = 0;
	red    = 0;
	case(current_state)
		GO:
		begin
			green = 1;
			if(contador == 5) next_state = WAIT;
			else 
			begin
				contador = contador + 4'b1;
				next_state = GO;
			end
		end
		WAIT:
		begin
			yellow = 1;
			if(contador == 7) next_state = STOP;
			else
			begin
				contador = contador + 4'b1;
				next_state = WAIT;
			end
		end
		STOP:
		begin
			red = 1;
			if(contador == 11) 
			begin 
				contador = 0;
				next_state = GO;
			end
			else 
			begin
				contador = contador + 4'b1;
				next_state = STOP;
			end
		end
	endcase
end

endmodule

