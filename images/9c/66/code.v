module top_module(
  input [n-1:0] dist_signal,
  input [n-1:0] ref_signal,
  output [n-1:0] eq_signal
);parameter n = 8; // number of input and output signals

reg [n-1:0] weights; // set of coefficients (weights)
reg [n-1:0] error; // difference between distorted and reference signals

// Least Mean Squares algorithm for adaptive equalization
always @(*) begin
  error = dist_signal - ref_signal;
  weights = weights - (error * dist_signal);
end

// Equalization circuit
assign eq_signal = dist_signal * weights;

endmodule