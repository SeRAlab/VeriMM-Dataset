module top_module(
  input wire clk,
  input wire rst,
  input wire [n-1:0] vctrl,
  output reg vco_out
);parameter fmin = 1000000; // minimum output frequency of VCO
parameter fmax = 2000000; // maximum output frequency of VCO
parameter n = 8; // number of bits used to represent the control voltage

reg [31:0] count; // counter for VCO output waveform
reg [31:0] threshold; // threshold value for VCO output waveform

always @(*) begin
  threshold = ((fmax - fmin) * vctrl) / (2 ** n) + fmin;
end

always @(posedge clk) begin
  if (rst) begin
    count <= 0;
    vco_out <= 0;
  end else begin
    count <= count + 1;
    if (count >= threshold) begin
      count <= 0;
      vco_out <= ~vco_out;
    end
  end
end

endmodule