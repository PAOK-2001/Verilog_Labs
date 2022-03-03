module counter(
	input      clk, rst,
	input[2:0] select,
	output reg maxReached
);

reg[2:0] count;
/* Enfoque 1: */
always@(posedge clk or negedge rst)
begin 
	if(!rst)
		count <= 3'b000;
	else if(select[0] == 1)
		begin
		if(count>= 5) 
			begin
			count <= 3'b000;
			maxReached = 1;
			end
		else 
			begin
			maxReached = 0;
			count <= count + 7'b0000001;
			end
		end
		
	else if(select[1] == 1)
		begin
		if(count>= 2) 
		begin
		count <= 3'b000;
		maxReached = 1;
		end
		else 
			begin
			count <= count + 7'b0000001;
			maxReached = 0;
			end
		end
		
	else if(select[2] == 1)
		begin
		if(count>= 4) 
		begin
		count <= 3'b000;
		maxReached = 1;
		end
		else
			begin
			maxReached = 0;
			count <= count + 7'b0000001;
			end
		end
end

endmodule
