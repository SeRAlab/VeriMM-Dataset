module top_module(a, b, s);input [32 - 1 : 0] a;
input [32 - 1 : 0] b;
output [32 - 1 : 0] s;

assign s = a + b;endmodule