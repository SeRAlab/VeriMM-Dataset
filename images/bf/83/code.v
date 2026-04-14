module top_module(
  input [n-1:0] data,
  input enable,
  input rs,
  output [m-1:0] ctrl
);parameter n = 8; // number of data signals
parameter m = 3; // number of control signals

assign ctrl[0] = enable & rs; // Register Select
assign ctrl[1] = enable & ~rs; // Read/Write
assign ctrl[2] = enable & data; // Data

endmodule