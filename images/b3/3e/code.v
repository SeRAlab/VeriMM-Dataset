module top_module(
  input clk,
  input rst,
  input [7:0] operand1,
  input [7:0] operand2,
  input [1:0] operation,
  output reg [7:0] result,
  output reg valid
);always @(posedge clk) begin
    if (rst) begin
      result <= 8'b0;
      valid <= 1'b0;
    end else begin
      case(operation)
        2'b00: begin // Addition
          result <= operand1 + operand2;
          valid <= 1'b1;
        end
        2'b01: begin // Subtraction
          result <= operand1 - operand2;
          valid <= 1'b1;
        end
        2'b10: begin // Multiplication
          result <= operand1 * operand2;
          valid <= 1'b1;
        end
        2'b11: begin // Division
          result <= operand1 / operand2;
          valid <= 1'b1;
        end
        default: begin
          result <= 8'b0;
          valid <= 1'b0;
        end
      endcase
    end
  end
endmodule