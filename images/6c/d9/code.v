module top_module(
  input clk,
  input rst,
  input [n-1:0] fcw,
  input [31:0] ref_freq,
  output reg [31:0] out_freq, // Changed to reg since it will be assigned in always block
  output reg locked // Changed to reg since it will be assigned in always block
);parameter n = 16;
parameter pll_based = 1; // set to 1 for PLL-based design, 0 for DDS-based design

reg [31:0] phase_accumulator;
reg [n-1:0] phase_increment;

always @(posedge clk) begin
  if (rst) begin
    phase_accumulator <= 0;
    phase_increment <= 0;
    out_freq <= 0; // Resetting out_freq
    locked <= 0;
  end else begin
    phase_accumulator <= phase_accumulator + phase_increment;
    out_freq <= (phase_accumulator >> 32) * ref_freq; // Adjusted for correct frequency calculation
    if (pll_based) begin
      // PLL-based design
      // TODO: implement PLL circuitry
    end else begin
      // DDS-based design
      // TODO: implement DDS circuitry
    end
    if (out_freq == fcw) begin
      locked <= 1;
    end else begin
      locked <= 0;
    end
  end
end

endmodule