module top_module(
  input clk, // reference clock signal
  input [7:0] V_ctrl, // voltage control signal
  output reg vco // VCO signal
);parameter f_clk = 50_000_000; // frequency of the reference clock signal
parameter V_min = 0; // minimum voltage of the voltage control signal
parameter V_max = 255; // maximum voltage of the voltage control signal
parameter f_min = 1_000_000; // minimum frequency of the VCO signal
parameter f_max = 10_000_000; // maximum frequency of the VCO signal

reg [31:0] count = 0;
reg [31:0] divider = 0;
reg [31:0] width = f_clk / (2 * f_max);

always @(posedge clk) begin
  count <= count + 1;
  if (count >= divider) begin
    vco <= ~vco;
    count <= 0;
  end
end

always @(*) begin
  divider = (f_clk * (V_ctrl - ((V_min + V_max) / 2)) * (f_max - f_min)) / ((V_max - V_min) * f_min * f_max);
end

endmodule