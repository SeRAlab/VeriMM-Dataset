module top_module(
  input clk,
  input rst,
  input [n-1:0] in,
  input [m-1:0] coeff,
  output reg out // Change output to reg type
);parameter n = 4; // number of input signals
parameter m = 3; // number of filter coefficients

reg [n-1:0] shift_reg; // shift register to store past input values
reg [m-1:0] coeff_reg; // register to store filter coefficients
reg [n+m-2:0] mult_reg; // register to store intermediate multiplication results
reg [n+m-2:0] sum_reg; // register to store intermediate sum results

always @(posedge clk) begin
  if (rst) begin
    shift_reg <= 0;
    coeff_reg <= coeff;
    mult_reg <= 0;
    sum_reg <= 0;
    out <= 0;
  end else begin
    shift_reg <= {in, shift_reg[n-1:1]};
    mult_reg <= {shift_reg, coeff_reg} * {n{1'b1}}; // This line might require revision
    sum_reg <= sum_reg + mult_reg;
    out <= sum_reg[n+m-2: m-1];
  end
end

endmodule