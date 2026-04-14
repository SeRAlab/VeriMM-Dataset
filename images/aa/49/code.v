module top_module(
  input data_in,
  input clk_in,
  output reg clk_out // Changed to reg type
);parameter clk_div = 2; // clock divider value

reg [31:0] phase_accumulator;
reg [31:0] phase_accumulator_last;
reg [31:0] phase_difference;
reg [31:0] phase_difference_last;
reg [1:0] control_signal;
reg [1:0] control_signal_last;

always @(posedge clk_in) begin
  phase_accumulator_last <= phase_accumulator;
  phase_accumulator <= phase_accumulator + control_signal_last;
  phase_difference_last <= phase_difference;
  phase_difference <= phase_accumulator - phase_accumulator_last;
  control_signal_last <= control_signal;
  control_signal <= phase_difference[31] ? 2'b10 : (phase_difference[30] ? 2'b01 : 2'b00);
end

reg [31:0] vco_output;
reg [31:0] vco_output_last;

always @(posedge clk_in) begin
  vco_output_last <= vco_output;
  vco_output <= vco_output_last + control_signal_last;
end

reg [31:0] clk_div_counter;

always @(posedge clk_in) begin
  if (clk_div_counter == clk_div - 1) begin
    clk_div_counter <= 0;
    clk_out <= ~clk_out;
  end else begin
    clk_div_counter <= clk_div_counter + 1;
  end
end

endmodule