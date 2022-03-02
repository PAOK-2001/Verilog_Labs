module Password(
	input clk, rst, confirm,
	input[3:0] inputData,
	output reg admitted,
	output reg[6:0] display1, display2, display3, display4
);

reg [3:0] value;
wire[6:0] display_value;

BCD DISPLAY_SET(
	.num(value),
	.display7Segment(display_value)
);

parameter	idle = 0,
				// Estados de registro de contraseña
				R1   = 1,
				R2   = 2,
				R3   = 3,
				R4   = 4;
				// Estados de entrada de contraseña
	
				
				
reg[2:0] current_state, next_state;
reg[3:0] target[3:0];

always @(posedge clk or negedge rst)
begin
	if(~rst)
		current_state = idle;
	else
		current_state = next_state;
end

always @(current_state, confirm)
begin
	admitted = 0;
	case(current_state)
		idle:
		begin
			if(~confirm) next_state <= R1;
			else         next_state <= idle;
		end
		// Estados de registro de contraseña
		R1:
		begin
			if(~confirm)
				begin
				target[0]  <= inputData;
				value      <= inputData;
				display1   <= display_value;
				next_state <= R2;
				end
			else next_state <= R1;
		end
		R2:
		begin
			if(~confirm)
				begin
				target[1]  <= inputData;
				value      <= inputData;
				display2   <= display_value;
				next_state <= R3;
				end
			else next_state <= R2;
		end
		R3:
		begin
			if(~confirm)
				begin
				target[2]  <= inputData;
				value      <= inputData;
				display3   <= display_value;
				next_state <= R4;
				end
			else next_state <= R3;
		end
		R4:
		begin
			if(~confirm)
				begin
				target[3]  <= inputData;
				value      <= inputData;
				display4   <= display_value;
				next_state <= idle;
				end
			else next_state <= R4;
		end
	endcase
	
end
endmodule
