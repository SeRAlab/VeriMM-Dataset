module top_module(clk, x, y);input clk;
input wire x;
output reg y;

always @(posedge clk) y <= x;endmodule