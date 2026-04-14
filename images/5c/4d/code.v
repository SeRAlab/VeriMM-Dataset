module top_module(A, B, S, C);input [3:0] A;
  input [3:0] B;
  output [3:0] S;
  output C;

  wire [3:0] sum;

  assign sum = A + B;

  assign S = sum[3:0];
  assign C = (sum > 4'hF);

endmodule