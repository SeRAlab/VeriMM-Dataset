module gray_code_converter (
  input [3:0] bin,
  output [3:0] gray);

assign gray = (bin >> 1) ^ bin;
endmodule