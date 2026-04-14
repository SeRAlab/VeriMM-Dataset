module top_module(
  input signed [15:0] audio_in,
  output reg speech_detected
);parameter fs = 16000; // sampling rate
parameter window_size = 256; // window size
parameter overlap = 128; // overlap between windows
parameter threshold = 100000; // energy threshold

reg signed [15:0] window [0:window_size-1];
reg signed [15:0] buffer [(fs/overlap)-1:0];
reg [31:0] energy;
reg [31:0] sum;

integer i, j;

always @(audio_in) begin
  // Shift window
  for (i = 0; i < window_size - overlap; i = i + 1) begin
    window[i] = window[i + overlap];
  end
  
  // Add new samples to window
  for (i = window_size - overlap; i < window_size; i = i + 1) begin
    window[i] = audio_in;
  end
  
  // Compute energy of window
  sum = 0;
  for (i = 0; i < window_size; i = i + 1) begin
    sum = sum + window[i] * window[i];
  end
  energy = sum >> 8; // divide by window size
  
  // Shift buffer
  for (i = 0; i < (fs/overlap) - 1; i = i + 1) begin
    buffer[i] = buffer[i + 1];
  end
  
  // Add energy to buffer
  buffer[(fs/overlap) - 1] = energy;
  
  // Check if speech is present
  sum = 0;
  for (i = 0; i < (fs/overlap); i = i + 1) begin
    sum = sum + buffer[i];
  end
  if (sum > threshold) begin
    speech_detected = 1;
  end
  else begin
    speech_detected = 0;
  end
end

endmodule