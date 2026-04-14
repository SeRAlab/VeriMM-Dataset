module top_module(
  input [3:0] A,
  input [3:0] B,
  input [3:0] C,
  input [3:0] D,
  input [1:0] E,
  input [1:0] F,
  input [1:0] G,
  input [1:0] H,
  output Y
);wire [15:0] ABCD = {A, B, C, D};
  wire [7:0] EFGH = {E, F, G, H};
  wire [31:0] result = ABCD * EFGH;

  assign Y = result[31];

endmodule