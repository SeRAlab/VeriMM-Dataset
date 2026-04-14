module top_module(x0, x1, s, c);input x0, x1, s;
output c;
assign c = (x0 & ~s) | (x1 & s);endmodule