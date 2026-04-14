module top_module(
  input [n-1:0] distorted_signal,
  input [n-1:0] known_signal,
  output reg [n-1:0] equalized_signal // Change to 'reg' type since it's assigned in always block
);parameter n = 4; // number of input signals

reg [n-1:0] tap_coefficients; // tap coefficient vector

reg [n-1:0] error; // error signal

reg [n-1:0] temp; // temporary signal

integer i; // loop variable

initial begin
  tap_coefficients = 0; // initialize tap coefficients to zero
end

always @(distorted_signal or known_signal) begin
  error = distorted_signal - known_signal; // compute error signal
  for (i = 0; i < n; i = i + 1) begin
    temp[i] = tap_coefficients[i] + (error[i] * known_signal[i]); // update tap coefficients using LMS algorithm
  end
  tap_coefficients = temp; // update tap coefficient vector
end

always @(distorted_signal or tap_coefficients) begin
  for (i = 0; i < n; i = i + 1) begin
    equalized_signal[i] = distorted_signal[i] - tap_coefficients[i]; // compute equalized signal using tap coefficient vector
  end
end

endmodule