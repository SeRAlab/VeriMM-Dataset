module top_module(
  input [3:0] a,
  input [3:0] b,
  input cin,
  output [3:0] sum,
  output cout
);wire [3:0] temp_sum;
  wire carry1, carry2, carry3;

  assign {carry1, temp_sum[0]} = a[0] + b[0] + cin;
  assign {carry2, temp_sum[1]} = a[1] + b[1] + carry1;
  assign {carry3, temp_sum[2]} = a[2] + b[2] + carry2;
  assign {cout, temp_sum[3]} = a[3] + b[3] + carry3;

  assign sum = temp_sum;

endmodule