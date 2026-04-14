module top_module(a, b, op, clk, result);input [7:0] a, b;
  input [1:0] op;
  input clk;
  output [7:0] result;

  reg [7:0] temp_result;
  
  always @(posedge clk) begin
    case(op)
      2'b00: temp_result <= a + b; // addition
      2'b01: temp_result <= a - b; // subtraction
      2'b10: temp_result <= a * b; // multiplication
      2'b11: temp_result <= a / b; // division
    endcase
  end
  
  assign result = temp_result;
  
endmodule