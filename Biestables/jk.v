module jk(
	input clk, clc, pr, J, K,
	output reg  q, 
	output reg [6:0]  display7Segment
);


always@(posedge clk)
begin
	if(clc == 0)
		q = 1'b0;
	else if (pr == 0)
		q = 1'b1;
	case({J,K})
		2'b00:
			q <= q;
		2'b10:
			q = 1'b1;
		2'b01:
			q = 1'b0;
		2'b11:
		q <= ~q;
	endcase
end

always@(q)
begin 
	case(q)
	0:
		display7Segment = 7'b1000000;
	1:
		display7Segment = 7'b1111001;
	endcase
end




endmodule
