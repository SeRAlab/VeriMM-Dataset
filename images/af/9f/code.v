module top_module(y,a,b,c);parameter N = 8;
output [N-1:0]y;
input [N-1:0]a,b,c;

assign y = (a+b)+c;

endmodule