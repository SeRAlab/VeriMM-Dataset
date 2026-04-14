module top_module(clk, rst, opcode, operand1, operand2, result, valid);input clk;
  input rst;
  input [1:0] opcode;
  input signed [7:0] operand1;
  input signed [7:0] operand2;
  output reg signed [7:0] result;
  output reg valid;

  always @(posedge clk) begin
    if (rst) begin
      result <= 0;
      valid <= 0;
    end else begin
      case (opcode)
        2'b00: result <= operand1 + operand2; // addition
        2'b01: result <= operand1 - operand2; // subtraction
        2'b10: result <= operand1 * operand2; // multiplication
        2'b11: result <= operand1 / operand2; // division
      endcase
      valid <= 1;
    end
  end

endmodule