module top_module(A, B, C, CO);input [3:0] A, B;
  output [3:0] C;
  output CO;

  wire [3:0] sum;
  
  assign sum = A + B;
  assign C = sum[3:0];
  assign CO = sum[4];

endmodule