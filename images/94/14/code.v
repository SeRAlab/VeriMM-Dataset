module top_module(A, B, reset, C);input [3:0] A;
  input [3:0] B;
  input reset;
  output [3:0] C;

  wire [4:0] sum;

  assign sum = {1'b0, A} + {1'b0, B};

  assign C = reset ? 4'b0000 : sum[3:0];

endmodule