module top_module(
  input clk,
  input reset,
  input signed [15:0] x,
  input signed [15:0] d,
  output reg signed [15:0] y, // Changed to reg
  output reg signed [15:0] e   // Changed to reg
);parameter n = 16; // number of filter taps
parameter mu = 16'h0001; // step size parameter (adjusted for fixed-point arithmetic)

reg signed [15:0] w [0:n-1]; // filter coefficients
reg signed [15:0] y_reg; // filter output register
reg signed [15:0] e_reg; // error signal register

integer i;

always @(posedge clk) begin
  if (reset) begin
    // reset filter coefficients to zero
    for (i = 0; i < n; i = i + 1) begin
      w[i] <= 0;
    end
    // reset filter output and error signal registers
    y_reg <= 0;
    e_reg <= 0;
    y <= 0; // Added to reset y
    e <= 0; // Added to reset e
  end else begin
    // compute filter output
    y_reg = 0; // Use blocking assignment
    for (i = 0; i < n; i = i + 1) begin
      y_reg = y_reg + w[i] * x;
    end
    y <= y_reg; // Non-blocking assignment for output register
    // compute error signal
    e_reg <= d - y_reg; // Non-blocking assignment for error calculation
    e <= e_reg; // Non-blocking assignment for output error signal
    // update filter coefficients using LMS algorithm
    for (i = 0; i < n; i = i + 1) begin
      w[i] <= w[i] + mu * e_reg * x; // Non-blocking assignment
    end
  end
end

endmodule