module top_module(
  input in,
  input Vthp,
  input Vthn,
  output out
);reg prev_out;

  always @(in or Vthp or Vthn or prev_out) begin
    if (in > Vthp) begin
      prev_out <= 1;
    end else if (in < Vthn) begin
      prev_out <= 0;
    end
  end

  assign out = prev_out;

endmodule