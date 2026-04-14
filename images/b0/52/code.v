module counter_2bit_down (
  input clk,
  output reg [1:0] count);always @(posedge clk)
  count <= count - 1;

endmodule