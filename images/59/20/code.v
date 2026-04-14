module top_module (
	input [31:0] data,
	output [15:0] out_even);assign out_even = {data[30], data[28], data[26], data[24], data[22], data[20], data[18], data[16], data[14], data[12], data[10], data[8], data[6], data[4], data[2], data[0]};

endmodule