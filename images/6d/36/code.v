module top_module(
  input signed [31:0] dividend,
  input signed [31:0] divisor,
  input clk,  // Added clock input
  output reg signed [31:0] quotient  // Changed output to reg
);reg signed [31:0] remainder;
  reg signed [31:0] dividend_reg;
  reg signed [31:0] divisor_reg;
  reg signed [31:0] quotient_reg;
  reg signed [31:0] adder_input;
  reg signed [31:0] adder_output;
  reg [4:0] count;
  reg sign;

  always @(*) begin
    dividend_reg = dividend;
    divisor_reg = divisor;
    sign = (dividend_reg < 0) ^ (divisor_reg < 0);
    dividend_reg = (dividend_reg < 0) ? -dividend_reg : dividend_reg;  // Use proper absolute value handling
    divisor_reg = (divisor_reg < 0) ? -divisor_reg : divisor_reg;      // Use proper absolute value handling
  end

  always @(posedge clk) begin
    if (count == 0) begin
      remainder <= dividend_reg;  // Non-blocking assignment
      quotient_reg <= 0;          // Non-blocking assignment
      count <= 16;                // Initialize count to 16 (or another appropriate value)
    end else if (count > 0) begin
      if (remainder < 0) begin
        adder_input = divisor_reg - remainder;
        adder_output = remainder + adder_input;
        remainder <= adder_output;  // Non-blocking assignment
        quotient_reg[count-1] <= 0; // Non-blocking assignment
      end else begin
        adder_input = remainder - divisor_reg;
        adder_output = remainder - adder_input;
        remainder <= adder_output;  // Non-blocking assignment
        quotient_reg[count-1] <= 1; // Non-blocking assignment
      end
    end

    if (count == 1) begin  // assuming count will go from 16 to 1
      quotient <= sign ? -quotient_reg : quotient_reg; // Handle sign for the final quotient
    end

    count <= count - 1;  // Decrement the count
  end

endmodule