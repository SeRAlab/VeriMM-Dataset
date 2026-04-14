module top_module(
  input [1:0] op,
  input [15:0] operands,
  output reg [15:0] result
);always @(*)
  begin
    case(op)
      2'b00: result = operands[7:0] + operands[15:8];
      2'b01: result = operands[7:0] - operands[15:8];
      2'b10: result = operands[7:0] * operands[15:8];
      2'b11: begin
        if (operands[15:8] == 0)
          $display("Error: division by zero");
        else
          result = operands[7:0] / operands[15:8];
      end
      default: $display("Error: invalid operation");
    endcase

    if (result > 16'h7FFF)
      $display("Error: overflow");
    else if (result < -16'h8000)
      $display("Error: underflow");
  end

endmodule