module top_module(s,a,b,c);output s;
input a,b,c;

assign s = ~( a | b) | c;endmodule