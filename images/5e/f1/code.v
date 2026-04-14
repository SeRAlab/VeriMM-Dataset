module subtractor_8bit (
  input [7:0] a,
  input [7:0] b,
  output [7:0] diff,
  output borrow_out
);

  assign {borrow_out, diff} = a - b;

endmodule