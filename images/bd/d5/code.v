module top_module(
  Din,
  Dout
);input wire [39 : 0] Din;
output wire [15 : 0] Dout;

// Manual slicing of the input Din
assign Dout = Din[34:19];

endmodule