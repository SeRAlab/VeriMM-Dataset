module top_module(
  input signed [15:0] a,
  input signed [15:0] b,
  input [1:0] op,
  output reg signed [15:0] result
);always @(*) begin
    case (op)
      2'b00: result = a + b; // addition
      2'b01: result = a - b; // subtraction
      2'b10: result = a * b; // multiplication
      2'b11: result = a / b; // division
      default: result = 16'h0000; // default case (should never occur)
    endcase
  end

endmodule