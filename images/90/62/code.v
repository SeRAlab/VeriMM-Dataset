module top_module(
  input [7:0] dividend,
  input [7:0] divisor,
  output reg [7:0] quotient,
  output reg [7:0] remainder
);integer i;

  always @(*) begin
    quotient = 8'b0;
    remainder = dividend;
    for (i = 0; i < 8; i = i + 1) begin
      remainder = remainder << 1;
      quotient = quotient << 1;
      quotient[0] = remainder[7];
      if (remainder >= divisor) begin
        remainder = remainder - divisor;
        quotient[0] = 1'b1;
      end
    end
  end

endmodule