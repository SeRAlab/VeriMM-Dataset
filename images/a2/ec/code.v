module top_module(
  input wire [31 : 0] Din,
  output wire [23 : 0] Dout
);// Implementation of a slice operation using standard Verilog
  assign Dout = Din[30:7];

endmodule