module counter(
	input pb, rst, select,
	output reg[6:0] count
);

/* Enfoque 1: */
always@(negedge pb or negedge rst)
begin 
	if(~rst)
		count <= 7'b0000000;
	else if(select == 1)
		count <= count + 7'b1;
	else if(select == 0)
		count <= count - 7'b1;
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