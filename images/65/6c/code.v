module top_module(a, b, mode, clear, result);input [3:0] a;
  input [3:0] b;
  input [1:0] mode;
  input clear;
  output [3:0] result;

  reg [3:0] result_reg;

  always @ (a or b or mode or clear) begin
    case (mode)
      2'b00: result_reg = a + b;
      2'b01: result_reg = a - b;
      2'b10: result_reg = a * b;
      2'b11: result_reg = a / b;
    endcase

    if (clear) begin
      result_reg = 4'd0;
    end
  end

  assign result = result_reg;

endmodule