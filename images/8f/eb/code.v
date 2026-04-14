module top_module(o,x,y,i);input  [7:0] x,y;
input  [8:0] i  ;
output wire [7:0] o;

assign o = (i<x) ? x : ((i>y) ? y : i[7:0]);

endmodule