module top_module(
  input audio_in,
  output reg speech_detected // Change wire to reg since we need to assign values to it in an always block
);// Define the threshold value for speech detection
  parameter THRESHOLD = 100;

  // Define the energy of the audio signal
  reg [15:0] energy = 0;

  // Calculate the energy of the audio signal
  always @(posedge audio_in) begin
    energy <= energy + audio_in * audio_in;
  end

  // Compare the energy to the threshold value and generate the speech detection output signal
  always @(posedge audio_in) begin
    if (energy > THRESHOLD) begin
      speech_detected <= 1;
    end else begin
      speech_detected <= 0;
    end
  end

endmodule