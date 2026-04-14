module top_module(
  input [3:0] num1,
  input [3:0] num2,
  input [1:0] operation,
  output reg [3:0] result // Changed 'output' to 'output reg'
);always @(*) begin
    case(operation)
      2'b00: result = num1 + num2; // addition
      2'b01: result = num1 - num2; // subtraction
      2'b10: result = num1 * num2; // multiplication
      2'b11: result = num1 / num2; // division
      default: result = 4'b0000; // default case
    endcase
  end

endmodule