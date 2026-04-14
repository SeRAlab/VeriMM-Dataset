module top_module(
  input signed [31:0] dividend,
  input signed [31:0] divisor,
  output reg signed [31:0] quotient,
  output reg signed [31:0] remainder
);reg signed [31:0] rem;
  reg signed [31:0] quot;
  reg signed [31:0] pos_dividend;
  reg signed [31:0] pos_divisor;
  reg signed [31:0] pos_quot;
  
  always @(*) begin
    pos_dividend = (dividend < 0) ? -dividend : dividend;
    pos_divisor = (divisor < 0) ? -divisor : divisor;
    
    if (dividend < 0 && divisor < 0) begin
      pos_quot = pos_dividend / pos_divisor;
      quotient = pos_quot;
      remainder = pos_dividend % pos_divisor;
    end
    else if (dividend < 0) begin
      pos_quot = pos_dividend / pos_divisor;
      quotient = -pos_quot;
      remainder = pos_dividend % pos_divisor;
    end
    else if (divisor < 0) begin
      pos_quot = pos_dividend / pos_divisor;
      quotient = -pos_quot;
      remainder = pos_dividend % pos_divisor;
    end
    else begin
      pos_quot = pos_dividend / pos_divisor;
      quotient = pos_quot;
      remainder = pos_dividend % pos_divisor;
    end
  end
  
endmodule