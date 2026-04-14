module top_module(
  input [n-1:0] num1,
  input [n-1:0] num2,
  output reg greater, // Change to reg
  output reg equal,   // Change to reg
  output reg less     // Change to reg
);parameter n = 8; // number of bits in each binary number

reg [n-1:0] diff;
// Note: diff_abs, num1_abs, and num2_abs are not needed for this implementation.
always @(*) begin
  diff = num1 - num2;
  if (diff == 0) begin
    greater = 0;
    equal = 1;
    less = 0;
  end else if (diff > 0) begin
    greater = 1;
    equal = 0;
    less = 0;
  end else begin
    greater = 0;
    equal = 0;
    less = 1;
  end
end

endmodule