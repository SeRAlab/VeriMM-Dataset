module four_bit_comparator (
  input [3:0] A,
  input [3:0] B,
  output reg out
);

  always @(*) begin
    if (A > B) begin
      out = 1;
    end else begin
      out = 0;
    end
  end

endmodule
