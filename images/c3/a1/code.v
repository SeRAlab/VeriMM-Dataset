module addition_module(
  input [7:0] A,
  input [7:0] B,
  output [7:0] sum,
  output carry
);

  reg [8:0] temp_sum;

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