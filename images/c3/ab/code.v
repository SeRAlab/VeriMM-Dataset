module calculator(
  input signed [7:0] a,
  input signed [7:0] b,
  output reg signed [7:0] result,
  output reg overflow
);

  always @* begin
    result = a + b;
    if ((a[7] == b[7]) && (a[7] != result[7]))
      overflow = 1;
    else
      overflow = 0;
  end

endmodule