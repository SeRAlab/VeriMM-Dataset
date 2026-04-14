module top_module(a, b, c, y);input [15:0] a, b;
input [31:0] c;
output [31:0] y;
assign y = a*b + c;
endmodule