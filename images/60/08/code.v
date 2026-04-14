module comparator_4bit(
  input [3:0] a,
  input [3:0] b,
  output reg gt,
  output reg lt,
  output reg eq
);

  always @(*) begin
    gt = (a > b);
    lt = (a < b);
    eq = (a == b);
  end

endmodule