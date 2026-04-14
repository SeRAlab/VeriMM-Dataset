module top_module(input clk, input [7:0] a, input [7:0] b, input [1:0] op, output [7:0] result);reg [7:0] temp;
  
  always @ (posedge clk) begin
    case(op)
      2'b00: temp <= a + b; // Addition
      2'b01: temp <= a - b; // Subtraction
      2'b10: temp <= a * b; // Multiplication
      2'b11: temp <= a / b; // Division
      default: temp <= 8'b0; // Default value
    endcase
  end
  
  assign result = temp;
endmodule