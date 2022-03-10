module RAM #(parameter dataSize = 5, addressSize = 5)(
	input                          clk, wrt_en,
	input      [dataSize   -1 : 0] data_in, 
	input      [addressSize -1 : 0] adress,
	output reg [dataSize   -1 : 0] data_out 
);

reg[dataSize - 1:0] RAM_1[0:2**addressSize-1];

always@(posedge clk)
begin
	if(~wrt_en) RAM_1[adress] <= data_in;
	else data_out <= RAM_1[adress];
end

endmodule
