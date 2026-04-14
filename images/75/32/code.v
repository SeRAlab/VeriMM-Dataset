module top_module(
  input [n-1:0] in,
  input clk,
  input rst,
  output reg out
);parameter n = 8; // number of input signals
parameter k = 4; // number of filter taps
parameter frac_bits = 8; // number of fractional bits for fixed-point arithmetic

reg [n-1:0] input_reg [0:k-1]; // register array to store input signals
reg [n-1:0] coeff [0:k-1]; // coefficient array for filter taps
reg signed [n+frac_bits-1:0] prod_reg [0:k-1]; // register array to store products of input signals and coefficients
reg signed [n+frac_bits-1:0] sum_reg; // register to store sum of products

integer i, j; // loop counters

always @(posedge clk) begin
  if (rst) begin
    // reset filter to initial state
    for (i = 0; i < k; i = i + 1) begin
      input_reg[i] <= 0;
      coeff[i] <= 0;
      prod_reg[i] <= 0;
    end
    sum_reg <= 0;
  end else begin
    // shift input signals into register array
    for (i = k-1; i > 0; i = i - 1) begin
      input_reg[i] <= input_reg[i-1];
    end
    input_reg[0] <= in;
    
    // multiply input signals by coefficients and store in product register array
    for (i = 0; i < k; i = i + 1) begin
      prod_reg[i] <= $signed(input_reg[i]) * $signed(coeff[i]);
    end
    
    // sum products in product register array and store in sum register
    sum_reg <= 0;
    for (i = 0; i < k; i = i + 1) begin
      sum_reg <= sum_reg + prod_reg[i];
    end
    
    // output filtered signal
    out <= sum_reg[n+frac_bits-1:n] >> frac_bits;
  end
end

endmodule