module top_module(
  input Xin,
  input Yin,
  input BorrowIn,
  output Diff,
  output BorrowOut
);assign {BorrowOut, Diff} = Xin - Yin - BorrowIn;
endmodule