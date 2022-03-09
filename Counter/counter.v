module counter(
	input            clk, rst, en,
	output reg [6:0] count
);

/* Enfoque 1: */
always@(posedge clk)
begin 
	if(rst)
		count <= 4'b0000; // Iniciar el valor del contador en 0
	else if(en)
		count <= count + 1; // Si el contador esta habilidado, cada tik aumentarlo uno
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
