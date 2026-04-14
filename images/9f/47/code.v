module top_module(
  input [n-1:0] dividend,
  input [n-1:0] divisor,
  output [n-1:0] quotient,
  output [n-1:0] remainder
);parameter n = 8; // number of bits in the input and output signals

reg [n-1:0] dividend_reg;
reg [n-1:0] divisor_reg;
reg [n-1:0] quotient_reg;
reg [n-1:0] remainder_reg;
reg signed [n-1:0] dividend_signed;
reg signed [n-1:0] divisor_signed;
reg signed [n-1:0] quotient_signed;
reg signed [n-1:0] remainder_signed;
reg [n:0] dividend_abs;
reg [n:0] divisor_abs;
reg [n:0] quotient_abs;
reg [n:0] remainder_abs;
reg [n:0] temp_abs;

assign quotient = quotient_signed;
assign remainder = remainder_signed;

always @(*) begin
  dividend_reg = dividend;
  divisor_reg = divisor;
  dividend_signed = $signed(dividend_reg);
  divisor_signed = $signed(divisor_reg);
  dividend_abs = dividend_signed >= 0 ? dividend_signed : -dividend_signed;
  divisor_abs = divisor_signed >= 0 ? divisor_signed : -divisor_signed;
  quotient_signed = dividend_signed / divisor_signed;
  remainder_signed = dividend_signed % divisor_signed;
  quotient_abs = dividend_abs / divisor_abs;
  remainder_abs = dividend_abs % divisor_abs;
  temp_abs = remainder_abs << 1;
  if (temp_abs >= divisor_abs) begin
    quotient_abs = quotient_abs + 1;
    remainder_abs = temp_abs - divisor_abs;
  end
  if (dividend_signed < 0 && divisor_signed > 0 || dividend_signed > 0 && divisor_signed < 0) begin
    quotient_signed = -quotient_signed;
    remainder_signed = -remainder_signed;
  end
  quotient_reg = quotient_abs;
  remainder_reg = remainder_abs;
end

endmodule