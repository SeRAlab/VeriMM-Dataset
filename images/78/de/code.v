module top_module(
  input  wire [3:0] i,
  output wire [3:0] o
);assign o = i;

specify
  (i[3:0] => o[3:0]) = (1, 1);
endspecify

endmodule