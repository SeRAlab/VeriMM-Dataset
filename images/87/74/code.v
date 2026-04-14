module top_module(
  input [3:0] A,
  input [3:0] B,
  input mode,
  output [3:0] sum,
  output carry_out
);reg [3:0] temp_sum;
  reg carry_out_temp;

  always @(*) begin
    if (mode == 0) begin
      temp_sum = A + B;
      carry_out_temp = (temp_sum[3] == 1) ? 1 : 0;
    end
    else begin
      temp_sum = A - B;
      carry_out_temp = (temp_sum[3] == 0) ? 1 : 0;
    end
  end

  assign sum = temp_sum;
  assign carry_out = carry_out_temp;

endmodule