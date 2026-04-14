module top_module(
  input clk,
  input start,
  input [7:0] num1,
  input [7:0] num2,
  input [1:0] mode,
  output reg [7:0] result,
  output reg done
);reg [15:0] temp;

  always @(posedge clk) begin
    if (start) begin
      case (mode)
        0: temp = num1 + num2;
        1: temp = num1 - num2;
        2: temp = num1 * num2;
        3: temp = num1 / num2;
      endcase
      result <= temp[7:0];
      done <= 1;
    end else begin
      done <= 0;
    end
  end

endmodule