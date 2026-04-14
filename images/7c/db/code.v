module shift_register(
  input clk,
  input rst,
  input load,
  input direction,
  input [3:0] data_in,
  output reg [3:0] data_out
);

  always @(posedge clk or posedge rst) begin
    if (rst)
      data_out <= 4'd0;
    else if (load)
      data_out <= data_in;
    else if (direction)
      data_out <= data_out << 1;
    else
      data_out <= data_out >> 1;
  end

endmodule