module modulo_operator (
  input [15:0] dividend,
  input [3:0] divisor,
  output [3:0] remainder
);

  reg [15:0] dividend_reg;
  reg [3:0] divisor_reg;
  reg [3:0] remainder_reg;
  
  always @(*) begin
    dividend_reg = dividend;
    divisor_reg = divisor;
    
    if (divisor_reg == 0) begin
      remainder_reg = 0;
    end else begin
      if (dividend_reg < 0) begin
        remainder_reg = -((-dividend_reg) % divisor_reg);
      end else begin
        remainder_reg = dividend_reg % divisor_reg;
      end
    end
  end
  
  assign remainder = remainder_reg;

endmodule