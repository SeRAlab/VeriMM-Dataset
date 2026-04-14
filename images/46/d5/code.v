module top_module(a, b, cin, sum, cout);input signed [3:0] a;
  input signed [3:0] b;
  input [0:0] cin;
  output signed [3:0] sum;
  output [0:0] cout;
  
  wire [4:0] temp_sum;
  assign temp_sum = a + b + cin;
  
  assign sum = temp_sum[3:0];
  assign cout = (temp_sum[4] == 1'b1) ? 1'b1 : 1'b0;
endmodule