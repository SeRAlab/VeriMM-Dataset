module top_module(
  input clk,
  input reset,
  input op,
  input [7:0] num1,
  input [7:0] num2,
  output reg [7:0] result,
  output reg overflow
);reg [8:0] temp;

always @(posedge clk, posedge reset) begin
  if (reset) begin
    result <= 0;
    overflow <= 0;
  end
  else begin
    if (op == 0) begin // addition
      temp <= num1 + num2;
      if (temp > 255) begin
        overflow <= 1;
        result <= temp[7:0];
      end
      else begin
        overflow <= 0;
        result <= temp[7:0];
      end
    end
    else begin // subtraction
      temp <= num1 - num2;
      if (temp < 0) begin
        overflow <= 1;
        result <= temp[7:0];
      end
      else begin
        overflow <= 0;
        result <= temp[7:0];
      end
    end
  end
end

endmodule