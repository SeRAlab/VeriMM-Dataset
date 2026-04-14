module top_module(A,B,Bin,diff,Bout);parameter width = 4;
input [width-1:0]A,B;
input Bin;
output [width-1:0] diff;
output Bout;

assign {Bout,diff} = A - B - Bin;

endmodule