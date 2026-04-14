module top_module(
in,
out
);input [2:0] in;
output [1:0] out;

assign in0_xor_in1	= in[0] ^ in[1];
assign in0_and_in1	= in[0] & in[1];
assign out[1] = in0_xor_in1 & in[2] | in0_and_in1;
assign out[0] = in0_xor_in1 ^ in[2];endmodule