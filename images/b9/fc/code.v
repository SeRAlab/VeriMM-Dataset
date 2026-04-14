module top_module(
  input [31:0] a, b,
  input [1:0] op,
  output reg [31:0] result
);always @(*) begin
    case(op)
      2'b00: result = a + b; // Addition
      2'b01: result = a - b; // Subtraction
      2'b10: result = a * b; // Multiplication
      2'b11: result = a / b; // Division
      default: result = 0; // Default case
    endcase
  end

endmodule