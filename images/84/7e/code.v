module top_module(
  input clk_in,
  input reset,
  input enable,
  input [1:0] freq_sel,
  output reg clk_out
);parameter N = 8; // multiplication factor

reg [31:0] phase_accumulator;
reg [31:0] phase_accumulator_prev;
reg [31:0] phase_difference;
reg [31:0] phase_difference_filtered;
reg [1:0] freq_divider;
reg [31:0] filter_output;
reg [31:0] filter_output_prev;
reg [31:0] filter_coefficient;

always @ (posedge clk_in or posedge reset) begin
  if (reset) begin
    phase_accumulator <= 0;
    phase_accumulator_prev <= 0;
    phase_difference <= 0;
    phase_difference_filtered <= 0;
    freq_divider <= 0;
    filter_output <= 0;
    filter_output_prev <= 0;
    filter_coefficient <= 0;
    clk_out <= 0;
  end else if (enable) begin
    // Phase detector
    phase_accumulator <= phase_accumulator_prev + (N * freq_divider);
    phase_difference <= phase_accumulator - phase_accumulator_prev;
    phase_accumulator_prev <= phase_accumulator;
    
    // Low-pass filter
    filter_coefficient <= 0.01; // Filter coefficient (adjustable)
    filter_output <= (filter_coefficient * phase_difference_filtered) + ((1 - filter_coefficient) * filter_output_prev);
    phase_difference_filtered <= phase_difference;
    filter_output_prev <= filter_output;
    
    // Frequency selection
    case (freq_sel)
      2'b00: freq_divider <= 0; // Divide by 1
      2'b01: freq_divider <= 1; // Divide by 2
      2'b10: freq_divider <= 2; // Divide by 4
      2'b11: freq_divider <= 3; // Divide by 8
    endcase
    
    // Output clock signal
    if (filter_output >= 0) begin
      clk_out <= 1;
    end else begin
      clk_out <= 0;
    end
  end
end

endmodule