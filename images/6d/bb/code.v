module top_module(
  input [7:0] A,
  input [7:0] B,
  output reg [7:0] sum,
  output reg carry
);reg [8:0] temp_sum;

  always @ (A or B) begin
    temp_sum = A + B;
    if (temp_sum > 255) begin
      carry = 1;
      sum = temp_sum[7:0];
    end else begin
      carry = 0;
      sum = temp_sum[7:0];
    end
  end

endmodule