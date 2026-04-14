module shift_reg(
    input clk,
    input rst,
    input load,
    input shift_left,
    input shift_right,
    input [15:0] data_in,

    output [15:0] data_out
);

reg [15:0] data_out;

always @(posedge clk or posedge rst)
begin
  if (rst)
    data_out <= 16'b0;
  else if (load)
    data_out <= data_in;
  else if (shift_left)
    data_out <= data_out << 1;
  else if (shift_right)
    data_out <= data_out >> 1;
end

endmodule