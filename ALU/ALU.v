module ALU(
	input  [3:0]     num1, num2,
	input  [1:0]     operationSelect,
	input            shiftButton1, shiftButton2,
	output reg [7:0] result
);

always@(*)
begin
	if(shiftButton1 == 0)
	begin
		result <= num1 << num2;
	end
	
	else if(shiftButton2 == 0)
	begin
		result <= num1 >> num2;
	end
	
	else
	begin
		casex(operationSelect)
			0: // Suma
				result <= num1 + num2;
			
			1: // Resta
				result <= num1 - num2;
			
			2: // Multiplicacion
				result <= num1*num2;

			3: //Division
				result <= num1/num2;
			default:
				result <= 0;
		endcase
	end
	
end


endmodule

