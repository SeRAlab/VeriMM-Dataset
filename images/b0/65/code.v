module top_module(clk,rst,rstbs);input clk;
input rst;
output rstbs;

reg q1,q2;
wire rstbs;

assign rstbs=q2;

always @(posedge clk, posedge rst)

if (rst) {q1,q2} <= 2'b0;
else		{q1,q2} <= {1'b1,q1};


endmodule