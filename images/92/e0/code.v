module top_module(clk,c,a,b);input clk;
input a, b;
output [1:0] c;
reg [1:0] c;

(* ivl_synthesis_on *)
always @(posedge clk)
    c <= (a << 1) | b;

endmodule