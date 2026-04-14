module top_module(
  input [7:0] A,
  input [7:0] B,
  output reg [7:0] sum,
  output reg [7:0] difference,
  output reg [7:0] product,
  output reg [7:0] quotient
);always @* begin
    sum = A + B;
    difference = A - B;
    product = A * B;
    quotient = A / B;
    if (difference < 0) difference = 0;
    if (quotient < 0) quotient = 0;
  end

endmodule