module Full_Adder(
	input[1:0] bits,
	input carryIn,
	output reg result, carryOut
);

always @*
begin
 {carryOut, result} = bits[0]+bits[1] +carryIn;
end 
endmodule