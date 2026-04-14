module top_module(
  output O,
  input A0, A1, A2, A3, A4, A5, A6
);parameter [127:0] INIT = 128'h0;
  assign O = INIT[{A6, A5, A4, A3, A2, A1, A0}];
endmodule