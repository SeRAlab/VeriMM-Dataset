module top_module(Dec2_in, Dec2_out);input [15:0] Dec2_in;
	output [8:0] Dec2_out;

	wire [15:0] d;
	assign d = Dec2_in;

	nor (Dec2_out[0], d[1], d[4], d[9], d[14], d[15]);
	nor (Dec2_out[1], d[6], d[7], d[8], d[9], d[10], d[11], d[12], d[13]);
	nor (Dec2_out[2], d[0], d[1], d[2], d[3], d[7], d[8], d[10], d[11], d[13]);
	nor (Dec2_out[3], d[0], d[2], d[7], d[10], d[15]);
	nor (Dec2_out[4], d[1], d[2], d[4], d[8], d[12], d[13], d[14]);
	nor (Dec2_out[5], d[1], d[2], d[3], d[7], d[8], d[9], d[12], d[13], d[14], d[15]);
	nor (Dec2_out[6], d[1], d[5], d[8], d[12], d[13], d[14]);
	nor (Dec2_out[7], d[0], d[2], d[5], d[6], d[8], d[15]);
	nor (Dec2_out[8], d[1], d[3], d[5], d[6], d[8], d[9], d[10], d[11], d[12]);endmodule