module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  output EQ,
  output LT,
  output GT
);parameter n = 8; // number of bits in each input signal

reg [n-1:0] diff;
reg [n-1:0] A_eq_B;
reg [n-1:0] A_lt_B;
reg [n-1:0] A_gt_B;

assign EQ = &A_eq_B;
assign LT = &A_lt_B;
assign GT = &A_gt_B;

always @* begin
  diff = A - B;
  A_eq_B = ~|diff;
  A_lt_B = (diff[n-1] == 1'b1) ? 1'b1 : &diff;
  A_gt_B = (diff[n-1] == 1'b0) ? 1'b1 : ~|diff;
end

endmodule