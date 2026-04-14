module top_module(clk, reset, op, a, b, result);input clk, reset;
  input [1:0] op;
  input [3:0] a, b;
  output reg [3:0] result;
  
  always @(posedge clk) begin
    if (reset) begin
      result <= 0;
    end else begin
      case (op)
        2'b00: result <= a + b; // addition
        2'b01: result <= a - b; // subtraction
        2'b10: result <= a * b; // multiplication
        2'b11: result <= a / b; // division
      endcase
    end
  end
endmodule