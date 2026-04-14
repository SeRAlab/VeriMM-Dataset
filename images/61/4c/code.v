module top_module(out, a, b, c, d);input a, b, c, d;
output out;

assign out=a | b | c | d;
endmodule