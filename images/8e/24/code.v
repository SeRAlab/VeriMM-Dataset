module top_module(
  input signed [15:0] osignal,
  input signed [15:0] esignal,
  input clk, // Added clk input to solve the issue with clock reference
  output reg signed [15:0] outsignal // Changed output to reg type
);parameter FIR_LENGTH = 32; // Length of FIR filter
  parameter MU = 16'd1; // Adjusted to fixed-point for better precision handling, using 16'd1 for the integer part

  reg signed [15:0] delay_line [0:FIR_LENGTH-1]; // Delay line
  reg signed [15:0] filtered_signal; // Filtered signal
  reg signed [15:0] error_signal; // Error signal
  reg signed [15:0] FIR_coefficients [0:FIR_LENGTH-1]; // FIR filter coefficients

  integer i; // Loop counter

  // Initialize delay line and FIR filter coefficients to zero
  initial begin
    for (i = 0; i < FIR_LENGTH; i = i + 1) begin
      delay_line[i] = 0;
      FIR_coefficients[i] = 0;
    end
  end

  // Update FIR filter coefficients using LMS algorithm
  always @(posedge clk) begin
    error_signal = osignal - filtered_signal; // Calculate error signal
    for (i = 0; i < FIR_LENGTH; i = i + 1) begin
      FIR_coefficients[i] = FIR_coefficients[i] + MU * error_signal * delay_line[i] >> 8; // Update FIR coefficients, bit-shift for fixed-point adjustment
    end
  end

  // Update delay line and filtered signal
  always @(posedge clk) begin
    filtered_signal = 0; // Reset filtered signal
    for (i = 0; i < FIR_LENGTH; i = i + 1) begin
      filtered_signal = filtered_signal + FIR_coefficients[i] * delay_line[i]; // Calculate filtered signal
      if (i == 0) begin
        delay_line[i] = esignal; // Update delay line with echoed signal
      end else begin
        delay_line[i] = delay_line[i-1]; // Shift delay line
      end
    end
    outsignal = osignal - filtered_signal; // Subtract echoed signal from original signal after passing it through FIR filter
  end

endmodule