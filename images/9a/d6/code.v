module top_module(out, x, y, s);input x, y, s;
output out;
assign out = (~s&x)|(s&y);endmodule