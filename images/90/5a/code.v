module top_module(
  input [N-1:0] dividend,
  input [N-1:0] divisor,
  input clk,
  input rst,
  output reg [N-1:0] quotient,
  output reg [N-1:0] remainder
);parameter N = 8; // number of bits for dividend and divisor

reg [N-1:0] dividend_reg;
reg [N-1:0] divisor_reg;
reg [N-1:0] quotient_reg;
reg [N-1:0] remainder_reg;
reg [N-1:0] dividend_shift_reg;
reg [N:0] counter_reg;

always @(posedge clk) begin
  if (rst) begin
    dividend_reg <= 0;
    divisor_reg <= 0;
    quotient_reg <= 0;
    remainder_reg <= 0;
    dividend_shift_reg <= {dividend, 1'b0};
    counter_reg <= N+1;
  end
  else begin
    dividend_reg <= dividend_shift_reg[N-1:0];
    divisor_reg <= divisor;
    quotient_reg <= 0;
    remainder_reg <= dividend_shift_reg[N-1:0];
    dividend_shift_reg <= {dividend_shift_reg[N-1:0], dividend_shift_reg[N]};
    if (counter_reg > 0) begin
      if (remainder_reg >= divisor_reg) begin
        remainder_reg <= remainder_reg - divisor_reg;
        quotient_reg <= {quotient_reg[N-2:0], 1'b1};
      end
      else begin
        quotient_reg <= {quotient_reg[N-2:0], 1'b0};
      end
      counter_reg <= counter_reg - 1;
    end
  end
end

assign quotient = quotient_reg;
assign remainder = remainder_reg[N-1:0];

endmodule