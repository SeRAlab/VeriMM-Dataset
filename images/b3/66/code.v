module top_module(
  input clk,
  input reset_n,
  input [7:0] operand1,
  input [7:0] operand2,
  input [1:0] operation,
  output reg [7:0] result,
  output reg valid
);reg [7:0] temp_result;

always @(*) begin
  case(operation)
    2'b00: temp_result = operand1 + operand2; // addition
    2'b01: temp_result = operand1 - operand2; // subtraction
    2'b10: temp_result = operand1 * operand2; // multiplication
    2'b11: temp_result = operand1 / operand2; // division
  endcase
end

always @(posedge clk or negedge reset_n) begin
  if (~reset_n) begin
    result <= 8'b0;
    valid <= 1'b0;
  end else begin
    result <= temp_result;
    valid <= 1'b1;
  end
end

endmodule