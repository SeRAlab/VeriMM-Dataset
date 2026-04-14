module top_module(
  input [3:0] a,
  input [3:0] b,
  input cin,
  output [3:0] sum,
  output cout
);wire [3:0] xor_out;
  wire [3:0] and_out;
  wire [3:0] or_out;

  // XOR gates
  assign xor_out[0] = a[0] ^ b[0];
  assign xor_out[1] = a[1] ^ b[1];
  assign xor_out[2] = a[2] ^ b[2];
  assign xor_out[3] = a[3] ^ b[3];

  // AND gates
  assign and_out[0] = a[0] & b[0];
  assign and_out[1] = a[1] & b[1];
  assign and_out[2] = a[2] & b[2];
  assign and_out[3] = a[3] & b[3];

  // OR gates
  assign or_out[0] = xor_out[0] ^ cin;
  assign or_out[1] = (xor_out[1] & xor_out[0]) ^ (cin & xor_out[1]);
  assign or_out[2] = (xor_out[2] & xor_out[1] & xor_out[0]) ^ (cin & xor_out[2] & (xor_out[1] ^ xor_out[0]));
  assign or_out[3] = (xor_out[3] & xor_out[2] & xor_out[1] & xor_out[0]) ^ (cin & xor_out[3] & (xor_out[2] ^ xor_out[1] ^ xor_out[0]));

  // Output signals
  assign sum[0] = xor_out[0];
  assign sum[1] = xor_out[1] ^ and_out[0];
  assign sum[2] = xor_out[2] ^ and_out[1] ^ or_out[0];
  assign sum[3] = xor_out[3] ^ and_out[2] ^ or_out[1];

  assign cout = and_out[3] ^ or_out[2];

endmodule