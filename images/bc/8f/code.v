module binary_counter_7bit_max(
  input clk,
  input rst_n,
  input [6:0] max_value,
  output reg [6:0] count
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      count <= 7'b0000000;
    else if (count == max_value)
      count <= 7'b0000000;
    else
      count <= count + 1;
  end

endmodule