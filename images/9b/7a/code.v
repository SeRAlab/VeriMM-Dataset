module top_module(
  input signed [15:0] mic_in,
  input signed [15:0] spkr_in,
  input clk, // Added clock input
  output reg signed [15:0] out // Changed to reg since we are assigning in always block
);parameter N = 32; // length of the filter
parameter mu = 0.01; // step size for the LMS algorithm

reg signed [15:0] filter_taps [0:N-1]; // filter taps
reg signed [15:0] delayed_mic_in [0:N-1]; // delayed microphone input
reg signed [15:0] error; // error signal
reg signed [15:0] filtered_spkr_in; // filtered speaker input
reg signed [15:0] filtered_mic_in; // filtered microphone input
reg signed [15:0] sum; // sum of filtered inputs

integer i; // loop index

// Delayed microphone input
always @(posedge clk) begin
  for (i = N-1; i > 0; i = i - 1) begin
    delayed_mic_in[i] <= delayed_mic_in[i-1];
  end
  delayed_mic_in[0] <= mic_in;
end

// Filtered speaker input
always @(posedge clk) begin
  filtered_spkr_in <= 0;
  for (i = 0; i < N; i = i + 1) begin
    filtered_spkr_in <= filtered_spkr_in + (spkr_in * filter_taps[i]); // Fix: use parentheses
  end
end

// Filtered microphone input
always @(posedge clk) begin
  filtered_mic_in <= 0;
  for (i = 0; i < N; i = i + 1) begin
    filtered_mic_in <= filtered_mic_in + (delayed_mic_in[i] * filter_taps[i]); // Fix: use parentheses
  end
end

// Error signal
always @(posedge clk) begin
  error <= filtered_mic_in - filtered_spkr_in;
end

// Update filter taps
always @(posedge clk) begin
  for (i = 0; i < N; i = i + 1) begin
    filter_taps[i] <= filter_taps[i] + (mu * error * delayed_mic_in[i]); // Fix: use parentheses
  end
end

// Output signal
always @(posedge clk) begin
  sum <= 0;
  for (i = 0; i < N; i = i + 1) begin
    sum <= sum + (spkr_in * filter_taps[i]); // Fix: use parentheses
  end
  out <= sum;
end

endmodule