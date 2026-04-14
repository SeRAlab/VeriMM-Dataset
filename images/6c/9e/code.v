module top_module(
  input ref_clk,
  input feedback_clk,
  input reset,
  input enable,
  output pll_clk,
  output dll_clk
);parameter freq_in = 50; // frequency of the reference clock signal
parameter freq_out = 100; // desired frequency of the output clock signal
parameter clk_div = 2; // division ratio used by the PLL to generate the output clock signal

reg [31:0] phase_accumulator;
reg [31:0] delay_line;
reg [31:0] delay_line_prev;
reg [31:0] phase_detector_out;
reg [31:0] vco_control_voltage;
reg [31:0] vco_control_voltage_prev;
reg [31:0] vco_out;
reg [31:0] vco_out_div;

wire ref_clk_delayed;
wire phase_detector_out_sign;
wire phase_detector_out_abs;

assign ref_clk_delayed = delay_line[31];

assign phase_detector_out_sign = phase_detector_out[31];
assign phase_detector_out_abs = (phase_detector_out_sign) ? (~phase_detector_out + 1) : phase_detector_out;

assign pll_clk = vco_out_div[31];

assign dll_clk = (ref_clk_delayed) ? (~delay_line + 1) : delay_line;

always @(posedge ref_clk or posedge reset) begin
  if (reset) begin
    phase_accumulator <= 0;
    delay_line <= 0;
    delay_line_prev <= 0;
    phase_detector_out <= 0;
    vco_control_voltage <= 0;
    vco_control_voltage_prev <= 0;
    vco_out <= 0;
    vco_out_div <= 0;
  end else begin
    phase_accumulator <= phase_accumulator + ((vco_control_voltage_prev + vco_control_voltage) >> 1);
    delay_line <= (enable) ? delay_line_prev + ((phase_detector_out_abs * freq_in) >> 1) : delay_line;
    phase_detector_out <= (enable) ? ((feedback_clk ^ ref_clk_delayed) ? (phase_accumulator >> 1) : 0) : 0;
    vco_control_voltage <= (enable) ? ((phase_detector_out_sign) ? (vco_control_voltage_prev - (phase_detector_out_abs >> 1)) : (vco_control_voltage_prev + (phase_detector_out_abs >> 1))) : 0;
    vco_out <= (enable) ? (vco_control_voltage >> 1) : 0;
    vco_out_div <= (enable) ? (vco_out >> clk_div) : 0;
    delay_line_prev <= delay_line;
    vco_control_voltage_prev <= vco_control_voltage;
  end
end

endmodule