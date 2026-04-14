module top_module(
  input in,
  output out
);parameter high_threshold = 1; // input signal greater than this is considered high
parameter low_threshold = 0; // input signal less than this is considered low

reg out_reg; // register to store the output signal

always @ (in) begin
  if (in > high_threshold) begin
    out_reg <= 1;
  end else if (in < low_threshold) begin
    out_reg <= 0;
  end
end

assign out = out_reg;

endmodule