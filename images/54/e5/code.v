module top_module(
  input op,
  input [3:0] a,
  input [3:0] b,
  output [3:0] result,
  output carry
);reg [4:0] temp_result;
  reg temp_carry;

  always @(*) begin
    if (op == 0) begin
      temp_result = a + b;
      temp_carry = (temp_result[4] == 1);
    end else begin
      temp_result = a - b;
      temp_carry = 0;
    end
  end

  assign result = temp_result[3:0];
  assign carry = temp_carry;

endmodule