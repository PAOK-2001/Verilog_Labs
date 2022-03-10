module CAM #(parameter dataSize = 5, addressSize = 5)(
	input                           clk, wrt, search,
	input      [dataSize   -1 : 0]  targetData,
	input      [addressSize -1 : 0] adress,
	output reg [addressSize-1 : 0]  address_out,
	output reg found,
	output [6:0] dispU, dispT, dispData
);

reg [dataSize - 1:0]    CAM_1 [0:2**addressSize-1];
reg [addressSize-1 : 0] searchedAddress;

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

BCD DATA(
	.num(targetData),
	.display7Segment(dispData)
);

always@(posedge clk)
begin
	if(~wrt)
	begin
		CAM_1[adress] <= targetData;
		address_out   = adress;
	end
	
	else if(~search && ~found)
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
	
	else begin
		searchedAddress = 0;
		found = 0;
	end

end

endmodule

