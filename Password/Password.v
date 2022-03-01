module Password(

	input clk, rst, 
	input[3:0] entryPassword, enable,

	output reg admitted
	
);

parameter	idle 	= 3'b000,
				k1 	= 3'b001,
				k2		= 3'b010,
				k3		= 3'b011,
				k4		= 3'b100;
				
reg[3:0] password = 4'b1010;
				
reg[2:0] current_state, next_state;

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
				
			if(enable[idle] == 1) 
			begin
			
				if(entryPassword[idle] == password[idle]) next_state = k1;
				else next_state = idle;
			
			end
			else next_state = idle;
					
		end
		k1:
		begin
				
			if(enable[k1] == 1) 
			begin
			
				if(entryPassword[k1] == password[k1]) next_state = k2;
				else next_state = idle;
			
			end
			else next_state = k1;
					
		end
		k2:
		begin
				
			if(enable[k2] == 1) 
			begin
			
				if(entryPassword[k2] == password[k2]) next_state = k3;
				else next_state = idle;
			
			end
			else next_state = k2;
					
		end
		k3:
		begin
				
			if(enable[k3] == 1) 
			begin
			
				if(entryPassword[k3] == password[k3]) next_state = k4;
				else next_state = idle;
			
			end
			else next_state = k3;
					
		end
		k4:
		begin
				
			admitted = 1;
			next_state = idle;
					
		end
	endcase
end

endmodule