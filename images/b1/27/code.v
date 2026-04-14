module top_module(
  Din,
  Dout
);input wire [39 : 0] Din;
output wire [15 : 0] Dout;

// Define a simple slice operation within this module
assign Dout = Din[32:17]; // This extracts bits 32 to 17 from Din

endmodule