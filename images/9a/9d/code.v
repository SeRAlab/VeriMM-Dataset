module top_module(
	input 	[7:0]	i_data,
	output	[3:0]	o_count
);assign o_count = ((i_data[0] + i_data[1] + i_data[2]) + (i_data[3] + i_data[4] +  i_data[5]) + i_data[6]) + i_data[7];
endmodule