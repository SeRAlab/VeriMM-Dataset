module calculator (
  input clk,
  input reset_n,
  input [31:0] operand1,
  input [31:0] operand2,
  input [1:0] operation,
  output reg [31:0] result
);

  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      result <= 0;
    end else begin
      case (operation)
        2'b00: result <= operand1 + operand2;
        2'b01: result <= operand1 - operand2;
        2'b10: result <= operand1 * operand2;
        2'b11: result <= operand1 / operand2;
      endcase
    end
  end

endmodule