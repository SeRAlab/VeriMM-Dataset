module top_module(A, B, cin, S, cout);input [3:0] A;
  input [3:0] B;
  input cin;
  output [3:0] S;
  output cout;

  wire [4:0] sum;

  assign sum = {1'b0, A} + {1'b0, B} + {1'b0, cin};

  assign S = sum[3:0];
  assign cout = sum[4];

endmodule