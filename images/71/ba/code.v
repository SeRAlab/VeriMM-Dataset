module top_module(
  input signed [15:0] in1, // original audio signal
  input signed [15:0] in2, // echoed audio signal
  output reg signed [15:0] out // filtered audio signal
);parameter Fs = 8000; // sampling frequency in Hz
parameter Taps = 128; // number of filter taps
parameter Mu = 0.0001; // step size for adaptive filter algorithm

reg signed [15:0] delay_line [0:Taps-1]; // delay line for echoed audio signal
reg signed [15:0] filter_taps [0:Taps-1]; // filter taps for adaptive filter algorithm
reg signed [15:0] estimated_echo; // estimated echo signal

integer i;

always @(in2) begin
  // shift delay line and add new sample
  for (i = Taps-1; i > 0; i = i - 1) begin
    delay_line[i] <= delay_line[i-1];
  end
  delay_line[0] <= in2;
  
  // compute estimated echo signal
  estimated_echo = 0;
  for (i = 0; i < Taps; i = i + 1) begin
    estimated_echo = estimated_echo + filter_taps[i] * delay_line[i];
  end
  
  // subtract estimated echo signal from echoed audio signal to obtain filtered audio signal
  out <= in2 - estimated_echo; // Use non-blocking assignment
  
  // update filter taps using LMS algorithm
  for (i = 0; i < Taps; i = i + 1) begin
    filter_taps[i] <= filter_taps[i] - Mu * (out - in1) * delay_line[i]; // Use non-blocking assignment
  end
end

endmodule