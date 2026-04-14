module top_module(
  input [precision-1:0] angle,
  output reg [precision-1:0] sin,
  output reg [precision-1:0] cos,
  output reg [precision-1:0] tan
);parameter precision = 16; // number of bits used to represent the fixed-point numbers
parameter fractional_part = 8; // number of bits used to represent the fractional part of the fixed-point numbers

integer i;
reg [precision-1:0] fact;
reg [precision-1:0] angle_pow;
reg [precision-1:0] temp_sin, temp_cos, temp_tan;

always @(*) begin
  fact = 1;
  angle_pow = angle;
  temp_sin = angle;
  temp_cos = 1 << fractional_part;
  temp_tan = angle;

  for (i = 1; i < 10; i = i + 1) begin
    fact = fact * (2 * i) * (2 * i + 1);
    angle_pow = angle_pow * angle * angle >> fractional_part;
    if (i % 2 == 0) begin
      temp_sin = temp_sin + angle_pow / fact;
      temp_cos = temp_cos - angle_pow / fact;
    end else begin
      temp_sin = temp_sin - angle_pow / fact;
      temp_cos = temp_cos + angle_pow / fact;
    end
  end

  sin = temp_sin;
  cos = temp_cos;
  tan = temp_sin / temp_cos;
end

endmodule