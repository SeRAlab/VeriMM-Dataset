module top_module(
  input ref_clk,
  input fb_clk,
  input reset,
  output out_clk
);parameter f_ref = 10e6; // frequency of reference signal
parameter n = 32; // integer divider value for VCO
parameter m = 10; // fractional divider value for VCO
parameter f_out = 125e6; // desired frequency of output signal

reg [31:0] phase_accumulator;
reg [31:0] phase_increment;
reg [31:0] phase_difference;
reg [31:0] loop_filter_output;
reg [31:0] vco_frequency;

wire [31:0] fb_clk_divider;
wire [31:0] vco_clk;

assign fb_clk_divider = fb_clk / n;
assign vco_clk = vco_frequency / m;

always @(posedge ref_clk or posedge reset) begin
  if (reset) begin
    phase_accumulator <= 0;
    loop_filter_output <= 0;
    vco_frequency <= 0;
  end else begin
    phase_increment <= (f_out * m) / f_ref;
    phase_accumulator <= phase_accumulator + phase_increment;
    phase_difference <= fb_clk_divider - phase_accumulator[31:0];
    loop_filter_output <= loop_filter_output + (phase_difference >> 2);
    vco_frequency <= loop_filter_output;
  end
end

assign out_clk = vco_clk;

endmodule