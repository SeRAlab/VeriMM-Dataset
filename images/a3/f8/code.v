module mux_2to1(
  input sel,
  input in0,
  input in1,
  output reg out
);

  always @(*) begin
    if (sel) begin
      out = in1;
    end else begin
      out = in0;
    end
  end

endmodule