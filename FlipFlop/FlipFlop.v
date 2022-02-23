module FlipFlop
(

	input D, clk, rst,
	
	output reg Q, Q_negada

);

always @(posedge clk or posedge rst)
begin 

	if(rst)
	begin
	
		Q <= 0;
		Q_negada = ~Q;
		
	end

	else
	begin
	
		Q <= D;
		Q_negada = ~Q;
		
	end
	
	
end

endmodule
