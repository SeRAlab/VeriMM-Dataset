module Span12Mux_v3(
  input [11:0] I,
  input [3:0] select,
  output O
);

  wire [11:0] sel;
  assign sel = {select, 4'b0};

  assign O = I[sel];

endmodule