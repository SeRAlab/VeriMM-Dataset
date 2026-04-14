module top_module(
	input wire	[7:0]data1,
	input wire	[7:0]data2,
	output wire	[7:0]data_out
	);assign data_out =(data1>=data2)?(data1-data2):(data2-data1);
endmodule