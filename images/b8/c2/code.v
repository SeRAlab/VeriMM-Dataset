module top_module(f, a, b, c);input a, b, c;
output f;



assign f = a | b&~c;

endmodule