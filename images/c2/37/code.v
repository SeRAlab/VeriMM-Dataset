module calc(
  input [7:0] A,
  input [7:0] B,
  input OP,
  output [7:0] C
);

  wire [7:0] sum;
  wire [7:0] diff;

  assign sum = A + B;
  assign diff = A - B;

  assign C = OP ? diff : sum;

endmodule