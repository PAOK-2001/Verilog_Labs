module CAM #(parameter dataSize = 5, addressSize = 5)(
	input                          clk, enable, rst,
	input      [dataSize   -1 : 0] targetData, 
	output reg [addressSize-1 : 0] address_out,
	output reg found,
	output [6:0] dispU, dispT
);

reg [dataSize - 1:0]    CAM_1 [0:2**addressSize-1];
reg [addressSize-1 : 0] searchedAddress;

always@*
begin
	CAM_1[0] = 5;
	CAM_1[1] = 6;
	CAM_1[2] = 2;
	CAM_1[3] = 3;
	CAM_1[4] = 1;
	CAM_1[5] = 0;
	
	
end

wire [addressSize-1 : 0] units; 
wire [addressSize-1 : 0] tens;  

assign units = address_out % 10;
assign tens  = (address_out / 10) % 10;

BCD UNIT(
	.num(units),
	.display7Segment(dispU)
);

BCD TEN(
	.num(tens),
	.display7Segment(dispT)
);

always@(posedge clk)
begin
	if(~rst)
	begin	
		searchedAddress = 0;
		found = 0;
		address_out = 0;
	end
	
	else if(enable && ~found)
	begin
		if(CAM_1[searchedAddress] == targetData)
		begin
			found       = 1;
			address_out = searchedAddress;
		end
		
		else
		begin
			searchedAddress = searchedAddress +1;
			address_out     = 0;
			found           = 0;
		end
	end

end

endmodule

