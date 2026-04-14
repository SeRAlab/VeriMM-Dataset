module top_module(a, b, cin, sum, cout);input [3:0] a, b;
  input cin;
  output [3:0] sum;
  output cout;

  wire c1, c2, c3;

  assign c1 = a[0] & b[0];
  assign c2 = a[0] ^ b[0];
  assign sum[0] = c2 ^ cin;
  assign c3 = c1 | (c2 & cin);

  assign c1 = a[1] & b[1];
  assign c2 = a[1] ^ b[1];
  assign sum[1] = c2 ^ c3;
  assign c3 = c1 | (c2 & c3);

  assign c1 = a[2] & b[2];
  assign c2 = a[2] ^ b[2];
  assign sum[2] = c2 ^ c3;
  assign c3 = c1 | (c2 & c3);

  assign c1 = a[3] & b[3];
  assign c2 = a[3] ^ b[3];
  assign sum[3] = c2 ^ c3;
  assign cout = c1 | (c2 & c3);
endmodule