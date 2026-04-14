module top_module(input [3:0] a, b, output [3:0] y1, y2, y3);assign y1 = - (* foo = "bar" *) a;
assign y2 = a + (* foobar = 42 *) b;
assign y3 = a == b ? (* foobar *) y1 : y2;

endmodule