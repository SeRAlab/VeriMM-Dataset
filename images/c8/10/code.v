module comparator (
  input [3:0] A,
  input [3:0] B,
  output EQ,
  output GT
);
  wire [3:0] diff;
  wire [3:0] not_diff;
  
  assign diff = A - B;
  assign not_diff = ~diff;
  
  assign EQ = &not_diff;
  assign GT = diff[3] & not_diff[3];
endmodule