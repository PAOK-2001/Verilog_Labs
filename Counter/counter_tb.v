module counter_tb();

// Declaracion de variables prueba
reg clock;
reg reset;
reg enable;

wire [6:0] resultado;

counter UUT(
	.clk(clock), 
	.rst(reset), 
	.en(enable),
	.count(resultado)
);

initial begin
	clock = 0;
	forever #25 clock = ~clock;

end

initial begin
	// Condicional inicial
	reset  = 1;
	enable = 0;
	#75
	// Activar enable y esperar 3 ciclos
	reset  = 0;
	enable = 1;
	#125
	// Desactivar enable y esperar 3 ciclos
	reset  = 0;
	enable = 0;
	#125
	// Resetear y esperar dos ciclos
	reset = 1;
	enable = 0;
	#75
	$stop;
end

endmodule

