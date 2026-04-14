module top_module(TCK, TDIPPC, TMS, TDOPPC, TDOTSPPC);output TCK;
output TDIPPC;
output TMS;

input TDOPPC;
input TDOTSPPC;

	assign TCK = 1'b1;
	assign TDIPPC = 1'b1;
	assign TMS = 1'b1;endmodule