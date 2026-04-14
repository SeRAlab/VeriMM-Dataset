module top_module(
  input clk,
  input reset,
  input signed [n-1:0] in,
  output signed [m-1:0] out
);parameter n = 16; // number of input samples
parameter m = 16; // number of output samples
parameter k = 8; // number of filter coefficients

reg signed [n-1:0] shift_reg;
reg signed [m-1:0] delayed_out;
reg signed [k-1:0] coefficients = {8'sd1, 8'sd2, 8'sd3, 8'sd4, 8'sd5, 8'sd6, 8'sd7, 8'sd8};

integer i;

always @(posedge clk) begin
  if (reset) begin
    shift_reg <= 0;
    delayed_out <= 0;
  end else begin
    shift_reg <= {in, shift_reg[n-2:0]};
    delayed_out <= delayed_out + (coefficients * shift_reg[k-1:0]);
  end
end

assign out = delayed_out;

endmodule