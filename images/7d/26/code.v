module top_module(
  input clk,
  input rst,
  input [1:0] op,
  input [7:0] num1,
  input [7:0] num2,
  output [7:0] result,
  output valid);reg [7:0] result_reg;
  reg valid_reg;
  
  always@(posedge clk) begin
    if(rst) begin
      result_reg <= 8'b0;
      valid_reg <= 1'b0;
    end else begin
      case(op)
        2'b00: result_reg <= num1 + num2;
        2'b01: result_reg <= num1 - num2;
        2'b10: result_reg <= num1 * num2;
        2'b11: result_reg <= num1 / num2;
      endcase
      
      valid_reg <= 1'b1;
    end
  end
  
  assign result = result_reg;
  assign valid = valid_reg;
  
endmodule