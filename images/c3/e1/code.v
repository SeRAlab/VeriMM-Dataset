module modulo_operator (
  input [31:0] div, // the dividend
  input [31:0] divisor, // the divisor
  output [31:0] rem // the remainder
);

  reg [31:0] quotient;
  reg [31:0] product;

  // Check for errors
  always @(*) begin
    if (divisor == 0) begin
      $display("Error: divisor cannot be zero");
      rem = 0;
    end
    else if (div < 0) begin
      $display("Error: dividend cannot be negative");
      rem = 0;
    end
    else begin
      quotient = div / divisor;
      product = quotient * divisor;
      rem = div - product;
    end
  end

endmodule
