module mux_2to1_behavioral (
  input [3:0] a,
  input [3:0] b,
  input s,
  output reg [3:0] mux_out
);

  always @(*) begin
    if (s == 1'b0) begin
      mux_out = a;
    end else begin
      mux_out = b;
    end
  end

endmodule
