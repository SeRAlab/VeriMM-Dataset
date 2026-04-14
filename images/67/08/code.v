module top_module(

input	wire	[4:0]	c,
input	wire	[10:0]	data,
output	wire	[4:0]	next_crc

);wire	[10:0]	d = { 	data[0], data[1], data[2], data[3], data[4],
							data[5], data[6], data[7], data[8], data[9],
							data[10] };

	wire	[4:0]	q = {
		^d[10:9] ^ ^d[6:5] ^ d[3] ^ d[0] ^ c[0] ^ ^c[4:3],
		d[10] ^ ^d[7:6] ^ d[4] ^ d[1] ^ ^c[1:0] ^ c[4],
		^d[10:7] ^ d[6] ^ ^d[3:2] ^ d[0] ^ ^c[4:0],
		^d[10:7] ^^ d[4:3] ^ d[1] ^ ^c[4:1],
		^d[10:8] ^ ^d[5:4] ^ d[2] ^ ^c[4:2]
	};

	assign	next_crc = ~q;endmodule