module top_module(
  input [3:0] a,
  input [3:0] b,
  input cin,
  output [3:0] sum,
  output cout
);wire [3:0] xor_out;
  wire [3:0] and_out;

  assign xor_out = a ^ b;
  assign and_out = a & b;

  assign sum[0] = xor_out[0] ^ cin;
  assign sum[1] = xor_out[1] ^ and_out[0] ^ cin;
  assign sum[2] = xor_out[2] ^ and_out[1] ^ cin;
  assign sum[3] = xor_out[3] ^ and_out[2] ^ cin;

  assign cout = and_out[3] | (and_out[2] & xor_out[3]) | (and_out[1] & xor_out[2] & xor_out[3]) | (and_out[0] & xor_out[1] & xor_out[2] & xor_out[3]);

endmodule