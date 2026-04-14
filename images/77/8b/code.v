module top_module(
  input signed [31:0] in,
  output reg [31:0] out
);// Check the sign bit of the input number
  wire signed [31:0] sign_bit = in[31];

  // If the sign bit is 1, then the input number is negative
  wire signed [31:0] negated = ~in + 1;

  // If the input number is negative, negate the number by taking the two's complement of the number
  always @(*) begin
    if (sign_bit == 1) begin
      out = negated;
    end else begin
      out = in;
    end
  end

endmodule