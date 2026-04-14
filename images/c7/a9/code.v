module mux_2to1_enable (
  input a,
  input b,
  input enable,
  output reg mux_out
);

  always @ (a, b, enable) begin
    if (enable) begin
      mux_out = a;
    end else begin
      mux_out = b;
    end
  end

endmodule
