module top_module(
  input [n-1:0] ctrl,
  output [m-1:0] en
);parameter n = 4; // number of control signals
  parameter m = 2; // number of enable signals

  // Define Boolean functions to determine enable signals
  assign en[0] = ctrl[0] & ctrl[1];
  assign en[1] = ctrl[2] | ctrl[3];

endmodule