module top_module(
  input [n-1:0] audio_in,
  input clk, // Added clk input
  output reg speech_detected // Changed to reg type for assignment in always block
);parameter n = 256; // number of audio samples in each frame

reg [31:0] energy;
reg [31:0] prev_energy;
reg [31:0] energy_diff;
reg [1:0] vad_state;
reg [3:0] vad_counter;

parameter ENERGY_THRESHOLD = 500;
parameter ENERGY_DIFF_THRESHOLD = 50;
parameter VAD_COUNTER_THRESHOLD = 3;

integer i; // Declared i as an integer for loop

always @ (posedge clk) begin
  energy = 0;
  
  // Calculate energy
  for (i = 0; i < n; i = i + 1) begin
    energy = energy + audio_in[i] * audio_in[i];
  end
  
  energy_diff = energy - prev_energy;
  prev_energy = energy;
  
  case (vad_state)
    2'b00: begin // Silence state
      if (energy > ENERGY_THRESHOLD) begin
        vad_state = 2'b01; // Voiced state
        vad_counter = 0;
      end
    end
    2'b01: begin // Voiced state
      if (energy_diff < -ENERGY_DIFF_THRESHOLD) begin
        vad_state = 2'b10; // Unvoiced state
        vad_counter = 0;
      end
      else if (energy_diff > ENERGY_DIFF_THRESHOLD) begin
        vad_counter = vad_counter + 1;
        if (vad_counter >= VAD_COUNTER_THRESHOLD) begin
          speech_detected = 1;
          vad_state = 2'b00; // Silence state
        end
      end
      else begin
        vad_counter = 0;
      end
    end
    2'b10: begin // Unvoiced state
      if (energy_diff > ENERGY_DIFF_THRESHOLD) begin
        vad_state = 2'b01; // Voiced state
        vad_counter = 0;
      end
      else if (energy_diff < -ENERGY_DIFF_THRESHOLD) begin
        vad_counter = vad_counter + 1;
        if (vad_counter >= VAD_COUNTER_THRESHOLD) begin
          vad_state = 2'b00; // Silence state
        end
      end
      else begin
        vad_counter = 0;
      end
    end
  endcase
end

endmodule