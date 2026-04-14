module binary_subtractor
(
  input [3:0] a,
  input [3:0] b,
  output [4:0] diff
);

  assign diff = {1'b0, a} - {1'b0, b};

endmodule