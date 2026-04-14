module top_module(in, out);input wire[3: 0] in;
	output wire[3: 0] out;
	assign out[0] = in[0];
	assign out[1] = in[1] ^ in[0];
	assign out[2] = in[2] ^ in[1] ^ in[0];
	assign out[3] = in[3] ^ in[2] ^ in[1] ^ in[0];
endmodule