module top_module(
  input signed [n-1:0] dividend,
  input signed [n-1:0] divisor,
  output signed [n-1:0] quotient,
  output signed [n-1:0] remainder
);parameter n = 16; // number of bits in dividend and divisor
parameter signed_div = 1; // set to 1 for signed division, 0 for unsigned division.

reg signed [n-1:0] dividend_reg;
reg signed [n-1:0] divisor_reg;
reg signed [n-1:0] quotient_reg;
reg signed [n-1:0] remainder_reg;

always @(*) begin
  dividend_reg = dividend;
  divisor_reg = divisor;
  
  if (divisor == 0) begin
    quotient_reg = 0;
    remainder_reg = 0;
  end
  else if (signed_div == 1) begin // signed division
    if (dividend < 0) begin
      if (divisor < 0) begin
        dividend_reg = -dividend;
        divisor_reg = -divisor;
      end
      quotient_reg = -dividend_reg / divisor_reg;
    end
    else begin
      if (divisor < 0) begin
        divisor_reg = -divisor;
        quotient_reg = -dividend_reg / divisor_reg;
      end
      else begin
        quotient_reg = dividend_reg / divisor_reg;
      end
    end
    remainder_reg = dividend_reg - quotient_reg * divisor_reg;
  end
  else begin // unsigned division
    quotient_reg = dividend_reg / divisor_reg;
    remainder_reg = dividend_reg % divisor_reg;
  end
end

assign quotient = quotient_reg;
assign remainder = remainder_reg;

endmodule