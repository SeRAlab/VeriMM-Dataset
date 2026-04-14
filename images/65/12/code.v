module top_module(q, a);output [15:0] q;
input [7:0] a;

assign q = a * 192;

endmodule