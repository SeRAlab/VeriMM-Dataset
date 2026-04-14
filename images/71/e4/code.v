module top_module(
  input [7:0] a,
  input [7:0] b,
  input [7:0] c,
  output reg [7:0] min
);always @ (a, b, c) begin
    if (a <= b && a <= c)
      min = a;
    else if (b <= a && b <= c)
      min = b;
    else
      min = c;
  end

endmodule