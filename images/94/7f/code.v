module top_module(
  input clk,
  input reset,
  input [1:0] op,
  input [7:0] num1,
  input [7:0] num2,
  output reg [7:0] result,
  output reg overflow
);reg [15:0] temp_result;
  
  always @(posedge clk) begin
    if(reset) begin
      result <= 0;
      overflow <= 0;
      temp_result <= 0;
    end else begin
      case(op)
        2'b00: temp_result <= num1 * num2; // multiplication
        2'b01: temp_result <= num1 - num2; // subtraction
        2'b10: temp_result <= num1 + num2; // addition
        2'b11: if(num2 != 0) begin // division
                 temp_result <= num1 / num2;
               end else begin
                 temp_result <= 0;
               end
      endcase
      
      if(temp_result > 255) begin
        overflow <= 1;
        result <= temp_result[7:0];
      end else begin
        overflow <= 0;
        result <= temp_result[7:0];
      end
    end
  end
  
endmodule