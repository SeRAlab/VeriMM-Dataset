module top_module(
  Din,
  Dout
);input wire [31 : 0] Din;
output wire [23 : 0] Dout;

  // Replace xlslice with a simple slicing syntax since xlslice is not recognized
  assign Dout = Din[29:6];

endmodule