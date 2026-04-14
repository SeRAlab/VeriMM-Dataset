module top_module(
  input [31:0] div,
  input [31:0] dor,
  output [31:0] quo,
  output [31:0] rem
);// Check if divisor is zero
  assign quo = (dor == 0) ? 0 : div / dor;
  assign rem = (dor == 0) ? 0 : div % dor;

endmodule