module top_module(a, b, cin, sum, cout);input a, b, cin;
  output sum, cout;
  assign #2 sum = a ^ b ^ cin;
  assign #2 cout = a & b | a & cin | b & cin;endmodule