module Multiplexor_tb();

reg[1:0] entradas_reg;
reg seleccion_reg;
wire salida_wire;

Multiplexor test(
	.entradas(entradas_reg),
	.seleccion(seleccion_reg),
	.salida(salida_wire)

);

initial begin
	entradas_reg  = 2'b01;
	seleccion_reg = 1'b1;
	#20
	entradas_reg  = 2'b01;
	seleccion_reg = 1'b0;
	#20
	entradas_reg  = 2'b10;
	seleccion_reg = 1'b1;
	#20
	entradas_reg  = 2'b10;
	seleccion_reg = 1'b0;
	#20
	$stop;
end

endmodule