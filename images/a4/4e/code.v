module top_module(
  input clk, // Added the clk input
  input [7:0] in,
  input [7:0] echo_in,
  output reg [7:0] out // Changed out to reg type
);parameter N = 16; // Filter length
  parameter mu = 8'h01; // Step size (8-bit representation)
  parameter alpha = 8'h0A; // Forgetting factor (8-bit representation)

  reg signed [7:0] w [0:N-1]; // Filter coefficients
  reg signed [7:0] x [0:N-1]; // Input signal buffer
  reg signed [7:0] y [0:N-1]; // Output signal buffer
  reg signed [7:0] e; // Error signal
  reg signed [7:0] echo_est; // Estimated echo signal

  integer i;

  always @(posedge clk) begin
    // Shift input and output signal buffers
    for (i = N-1; i > 0; i = i - 1) begin
      x[i] <= x[i-1];
      y[i] <= y[i-1];
    end

    // Update input signal buffer with new input sample
    x[0] <= in;

    // Compute estimated echo signal
    echo_est = 0;
    for (i = 0; i < N; i = i + 1) begin
      echo_est = echo_est + w[i] * x[i];
    end

    // Compute error signal
    e = echo_in - echo_est;

    // Update filter coefficients using LMS algorithm
    for (i = 0; i < N; i = i + 1) begin
      w[i] <= w[i] + mu * e * x[i];
      w[i] <= w[i] - alpha * w[i];
    end

    // Compute output signal
    out <= in - echo_est; // Changed to non-blocking assignment
    // Shift output signal buffer
    for (i = N-1; i > 0; i = i - 1) begin
      y[i] <= y[i-1];
    end
    // Update output signal buffer with new output sample
    y[0] <= out;
  end

endmodule