module counter_tb();

// Declaracion de variables prueba
reg clock;
reg reset;
reg enable;

wire [3:0] resultado;

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
	// 
	reset  = 0;
	enable = 0;
	#25
	// Activar enable y esperar 3 ciclos
	enable = 1;
	#75
	// Desactivar enable y esperar 3 ciclos
	enable = 1;
	#75
	// Resetear y esperar dos ciclos
	reset = 0;
	#50
	$stop;
end

endmodule

