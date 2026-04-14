module top_module(a, b, cin, sum, cout);input [3:0] a;
  input [3:0] b;
  input cin;
  output [3:0] sum;
  output cout;

  wire [3:0] xor_out;
  wire [3:0] and_out;
  wire [3:0] xor2_out;
  wire [3:0] and2_out;
  wire [3:0] or_out;

  // Generate the sum bits
  assign xor_out = a ^ b;
  assign and_out = a & b;
  assign xor2_out = xor_out ^ cin;
  assign and2_out = xor_out & cin;
  assign sum = xor2_out ^ and_out;

  // Generate the carry-out bit
  assign or_out = and_out | and2_out;
  assign cout = or_out;

endmodule