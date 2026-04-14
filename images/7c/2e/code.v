module top_module(
   input clk,
   input din,
   output reg q
);always@(posedge clk)
   q <= din;

endmodule