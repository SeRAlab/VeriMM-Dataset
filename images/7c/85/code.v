module top_module(
  input clk,
  input reset,
  input enable,
  input [31:0] max_count,
  output reg [31:0] count
);always @(posedge clk or posedge reset)
    if (reset)
      count <= 0;
    else if (enable && count == max_count)
      count <= 0;
    else if (enable)
      count <= count + 1;

endmodule