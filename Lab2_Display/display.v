/* LAB 2

Display de 7 segmentos*/

module display(

	input[3:0] entryNum,
	output[6:0] displaySegment

);

assign displaySegment[0] = ~((~entryNum[2] & ~entryNum[0]) | (~entryNum[3] & entryNum[1]) | (~entryNum[3] & entryNum[2] & entryNum[0]) | (entryNum[3] & ~entryNum[2] & ~entryNum[1]) | (entryNum[3] & ~entryNum[0]) | (entryNum[2] & entryNum[1]));
assign displaySegment[1] = ~((~entryNum[3] & ~entryNum[1] & ~entryNum[0]) | (~entryNum[3] & entryNum[1] & entryNum[0]) | (~entryNum[2] & ~entryNum[0]) | (entryNum[3] & ~entryNum[1] & entryNum[0]) | (~entryNum[3] & ~entryNum[2]));							
assign displaySegment[2] = ~((~entryNum[3] & entryNum[2]) | (entryNum[3] & ~entryNum[2]) | (~entryNum[1] & entryNum[0]) | (~entryNum[3] & ~entryNum[1]) | (~entryNum[3] & entryNum[0]));				
assign displaySegment[3] = ~((entryNum[2] & ~entryNum[1] & entryNum[0]) | (~entryNum[3] & ~entryNum[2] & ~entryNum[0]) | (~entryNum[2] & entryNum[1] & entryNum[0]) | (entryNum[2] & entryNum[1] & ~entryNum[0]) | (entryNum[3] & ~entryNum[1]));
assign displaySegment[4] = ~((~entryNum[2] & ~entryNum[0]) | (entryNum[1] & ~entryNum[0]) | (entryNum[3] & entryNum[1]) | (entryNum[3] & entryNum[2]));
assign displaySegment[5] = ~((~entryNum[1] & ~entryNum[0]) | (~entryNum[3] & entryNum[2] & ~entryNum[1]) | (entryNum[2] & ~entryNum[0]) | (entryNum[3] & ~entryNum[2]) | (entryNum[3] & entryNum[1]));
assign displaySegment[6] = ~((~entryNum[2] & entryNum[1]) | (entryNum[2] & ~entryNum[1]) | (entryNum[3]) | (entryNum[1] & ~entryNum[0]));

endmodule