module top_module(
  input [3:0] a,
  input [3:0] b,
  input cin,
  output [3:0] sum,
  output cout
);wire c1, c2, c3; // intermediate carry signals

  // Full adder for bit 0
  assign sum[0] = a[0] ^ b[0] ^ cin; // Sum of the first bit
  assign c1 = (a[0] & b[0]) | ((a[0] ^ b[0]) & cin); // Carry out of the first bit

  // Full adder for bit 1
  assign sum[1] = a[1] ^ b[1] ^ c1; // Sum of the second bit
  assign c2 = (a[1] & b[1]) | ((a[1] ^ b[1]) & c1); // Carry out of the second bit

  // Full adder for bit 2
  assign sum[2] = a[2] ^ b[2] ^ c2; // Sum of the third bit
  assign c3 = (a[2] & b[2]) | ((a[2] ^ b[2]) & c2); // Carry out of the third bit

  // Full adder for bit 3
  assign sum[3] = a[3] ^ b[3] ^ c3; // Sum of the fourth bit
  assign cout = (a[3] & b[3]) | ((a[3] ^ b[3]) & c3); // Final carry out

endmodule