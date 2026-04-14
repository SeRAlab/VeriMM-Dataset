module top_module(cin, a, b, cout, sum);input cin;
  input [3:0] a, b;
  output cout;
  output [3:0] sum;

  wire [3:0] temp_sum;

  assign temp_sum = a + b + cin;

  assign sum = temp_sum[3:0];
  assign cout = temp_sum[4];

endmodule