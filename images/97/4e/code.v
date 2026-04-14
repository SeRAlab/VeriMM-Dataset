module top_module(
  input clk,
  input reset,
  input [7:0] num1,
  input [7:0] num2,
  input add,
  input sub,
  input mult,
  input div,
  input clear,
  output reg [7:0] result
);reg [7:0] prev_num1;
  reg [7:0] prev_num2;
  reg [7:0] prev_result;
  
  always @(posedge clk) begin
    if (reset) begin
      prev_num1 <= 0;
      prev_num2 <= 0;
      prev_result <= 0;
      result <= 0;
    end else begin
      if (clear) begin
        prev_num1 <= 0;
        prev_num2 <= 0;
        prev_result <= 0;
        result <= 0;
      end else begin
        if (num1 != prev_num1 || num2 != prev_num2 || add || sub || mult || div) begin
          if (add) begin
            prev_result <= num1 + num2;
          end else if (sub) begin
            prev_result <= num1 - num2;
          end else if (mult) begin
            prev_result <= num1 * num2;
          end else if (div) begin
            prev_result <= num1 / num2;
          end
          prev_num1 <= num1;
          prev_num2 <= num2;
          result <= prev_result;
        end
      end
    end
  end
  
endmodule