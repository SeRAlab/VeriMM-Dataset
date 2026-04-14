module top_module(
  input [n-1:0] ctrl,
  output [m-1:0] en
);parameter n = 4; // number of control signals
parameter m = 2; // number of enable signals

// Define subsets of control signals for each enable signal
parameter [n-1:0] en1_ctrls = 4'b0001;
parameter [n-1:0] en2_ctrls = 4'b0011;

// Implement the functionality of the control register block
assign en[0] = (ctrl & en1_ctrls) == en1_ctrls;
assign en[1] = (ctrl & en2_ctrls) == en2_ctrls;

endmodule