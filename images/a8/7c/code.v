module subtractor4bit (
  input [3:0] a,
  input [3:0] b,
  input bin,
  output [3:0] diff,
  output bout
);

  assign {bout, diff} = a - b - bin;

endmodule