module top_module(
  input [3:0] A,
  input [3:0] B,
  input S,
  input clk,
  output [3:0] C,
  output Cout
);wire [3:0] B_neg;
  wire [3:0] B_plus_1;
  wire [4:0] sum;
  
  assign B_neg = ~B + 1;
  assign B_plus_1 = B + 1;
  
  assign sum = {1'b0, A} + {S, B_neg};
  
  assign C = sum[3:0];
  assign Cout = sum[4];
  
endmodule