module top_module(
input wire clk, reset,en,
input wire d ,
output reg q
);always @(posedge clk, posedge reset)
if (reset)
q <= 1'b0;
 else if(en)
q <= d;endmodule