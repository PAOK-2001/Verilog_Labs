module Password(
	input clk, rst, confirm,
	input[3:0] inputData,
	output reg admitted,
	output [6:0] display1, display2, display3, display4
);

reg [3:0] value1,value2,value3,value4;

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
			value1      <= inputData;
			if(~rst) next_state = idle;
			if(~confirm)
				begin
				target[0]  <= inputData;
				next_state <= R2;
				end
			else next_state <= R1;
		end
		R2:
		begin
			value2      <= inputData;
			if(~rst) next_state = idle;
			if(~confirm)
				begin
				target[1]  <= inputData;
				next_state <= R3;
				end
			else next_state <= R2;
		end
		R3:
		begin
			value3      <= inputData;
			if(~confirm)
				begin
				target[2]  <= inputData;
				next_state <= R4;
				end
			else next_state <= R3;
		end
		R4:
		begin
			value4      <= inputData;
			if(~rst) next_state = idle;
			if(~confirm)
				begin
				target[3]  <= inputData;
				next_state <= idle;
				end
			else next_state <= R4;
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
endmodule
