module Full_Adder(
	// Bits de entrada
	input[1:0] bits,
	// Bit de carryIn
	input carryIn,
	// Salida
	output reg result, carryOut
);
// Detecta el cambio en cualquier variable
always @*
begin
 {carryOut, result} = bits[0]+bits[1] +carryIn;
end 
endmodule
