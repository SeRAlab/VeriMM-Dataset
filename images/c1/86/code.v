module gfadder(in1, in2, out);
input [0:4] in1, in2;
output [0:4] out;
assign out[4] = in1[4] ^ in2[4];
assign out[3] = in1[3] ^ in2[3];
assign out[2] = in1[2] ^ in2[2];
assign out[1] = in1[1] ^ in2[1];
assign out[0] = in1[0] ^ in2[0];
endmodule