module top_module(
  input [31:0] x, // angle in radians
  output reg [31:0] y // value of sine, cosine, or tangent function at x
);parameter n = 10; // number of terms to use in Taylor series approximation

reg [31:0] fact;
reg [31:0] x_pow;
reg [31:0] term;
reg [31:0] sum;
integer i;

always @(*) begin
  sum = 0;
  x_pow = x;
  fact = 1;
  for (i = 0; i < n; i = i + 1) begin
    if (i % 2 == 0) begin
      term = x_pow / fact;
    end else begin
      term = -x_pow / fact;
    end
    sum = sum + term;
    x_pow = x_pow * x * x;
    fact = fact * (2 * (i + 1)) * (2 * (i + 1) - 1);
  end
  y = sum;
end

endmodule