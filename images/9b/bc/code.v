module top_module(
  input in,
  output reg out
);parameter VL = 1; // low threshold value
parameter VH = 3; // high threshold value
parameter hysteresis = 1; // hysteresis value

reg prev_out; // previous output state

always @(in) begin
  if (in > VH) begin
    out = 1;
  end else if (in < VL) begin
    out = 0;
  end else if (in > (prev_out + hysteresis)) begin
    out = 1;
  end else if (in < (prev_out - hysteresis)) begin
    out = 0;
  end
  prev_out = out;
end

endmodule