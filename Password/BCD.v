module BCD(
	input      [6:0] num,
	output reg [6:0] display7Segment
);


always@(num)
begin
	casex(num)
	
	0:
		display7Segment = 7'b1000000;
	1:
		display7Segment = 7'b1111001;
	2:
		display7Segment = 7'b0100100;
	3:
		display7Segment = 7'b0110000;
	4:
		display7Segment = 7'b0011001;
	5:
		display7Segment = 7'b0010010;
	6:
		display7Segment = 7'b0000010;
	7:
		display7Segment = 7'b1111000;
	8:
		display7Segment = 7'b0000000;
	9:
		display7Segment = 7'b0010000;
	10:
		display7Segment = 7'b0001100;
	11:
		display7Segment = 7'b0001000;
	default:
		display7Segment = 7'b0011000;
	
	endcase

end
endmodule