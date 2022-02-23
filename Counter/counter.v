module counter(
	input clk, rst, en,
	output reg count[3:0]
);

/* Enfoque 1: */
always@(posedge clk)
begin 
	if(rst)
		count <= 4'b0000;
	else if(en)
		count <= count + 1;
end


/* Enfoque 2: Separar parte sequencial a parte logica
reg [3:0] count_d, count_q
assign count = count_q;
// Parte sequencial
always@(posedge, clk)
begin 
	if(rst)
		count_q <= 4'b0;
	else if(en)
		count_q <= count_d;
end
// Parte combicional
always*
begin
	if(counter_q < 4'd9)
		count_d = count_q +4'd1;
	else
		count_d = 4'd0;
end
*/
endmodule