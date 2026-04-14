module top_module(
  input [31:0] x,
  output [31:0] sin_x,
  output [31:0] cos_x,
  output [31:0] tan_x
);parameter n = 5; // number of terms in Taylor series approximation

reg [31:0] sin_approx;
reg [31:0] cos_approx;
reg [31:0] tan_approx;

integer i;
reg [31:0] numerator;
reg [31:0] denominator;
reg [31:0] power;

always @(*) begin
  // Calculate sine approximation
  sin_approx = x;
  numerator = x;
  denominator = 1;
  power = x;
  for (i = 1; i < n; i = i + 2) begin
    numerator = numerator * (-1) * x * x;
    denominator = denominator * (i + 1) * i;
    power = power * x * x;
    sin_approx = sin_approx + numerator / denominator;
  end
  
  // Calculate cosine approximation
  cos_approx = 1;
  numerator = 1;
  denominator = 1;
  power = x * x;
  for (i = 2; i < n; i = i + 2) begin
    numerator = numerator * (-1) * x * x;
    denominator = denominator * (i + 1) * i;
    power = power * x * x;
    cos_approx = cos_approx + numerator / denominator;
  end
  
  // Calculate tangent approximation
  tan_approx = sin_approx / cos_approx;
end

assign sin_x = sin_approx;
assign cos_x = cos_approx;
assign tan_x = tan_approx;

endmodule