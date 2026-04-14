module shift_register(
  input clk,
  input rst_n,
  input load,
  input direction,
  input [7:0] parallel_in,
  output reg [7:0] data_out
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      data_out <= 8'b00000000;
    else if (load)
      data_out <= parallel_in;
    else if (direction)
      data_out <= data_out >> 1;
    else
      data_out <= data_out << 1;
  end

endmodule