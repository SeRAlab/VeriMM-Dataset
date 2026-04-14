module top_module(
	input			clock,
	input			wren,
	input	[4:0]		wraddress,
	input	[4:0]		rdaddress,
	input	[8:0]		data,
	output	reg	[8:0]	q 
	);reg	[8:0]	mem_a [0:31];

always @(posedge clock) if(wren) mem_a[wraddress] <= data;

always @(posedge clock) q <= mem_a[rdaddress];


endmodule