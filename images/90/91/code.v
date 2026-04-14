module top_module(clk,d,q);input [31:0] d;
input clk;
output [31:0] q;

wire unused;
assign unused = clk;
assign q=d;

endmodule