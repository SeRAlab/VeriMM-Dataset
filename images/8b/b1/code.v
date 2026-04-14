module top_module(
  input clk,
  input reset,
  input in,
  input [n-1:0] coeff,
  output reg out // Changed to reg type
);parameter n = 8; // number of filter taps

reg [n-1:0] shift_reg; // shift register to store filter taps
reg [n-1:0] coeff_reg; // register to store coefficients

reg [31:0] acc; // accumulator to calculate output

always @(posedge clk) begin
  if (reset) begin
    shift_reg <= 0;
    coeff_reg <= coeff;
    acc <= 0;
    out <= 0; // Initialize output on reset
  end else begin
    shift_reg <= {in, shift_reg[n-1:1]};
    acc <= acc + (in * coeff_reg[n-1]); // Corrected accumulation
    coeff_reg <= {coeff_reg[n-1:1], coeff_reg[0]};
    out <= acc[n-1]; // Output assignment
  end
end

endmodule