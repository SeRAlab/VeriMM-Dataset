module top_module(
  input clk,
  input reset,
  input [7:0] num1,
  input [7:0] num2,
  output reg [8:0] sum
);reg [7:0] temp_sum;
  reg carry;

  always @ (posedge clk) begin
    if (reset) begin
      temp_sum <= 8'b0;
      carry <= 1'b0;
    end else begin
      temp_sum <= num1 + num2 + carry;
      carry <= (temp_sum > 8'b11111111) ? 1'b1 : 1'b0;
    end
  end

  assign sum = {carry, temp_sum};

endmodule