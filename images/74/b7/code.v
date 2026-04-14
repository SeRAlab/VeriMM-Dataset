module top_module(c, m);input [4:0] c;
    output [3:0] m;

    assign m[0] = c[0];
    assign m[1] = ~c[1];
    assign m[2] = c[2] & c[1] | c[4] & ~c[1];
    assign m[3] = c[4] & c[1];endmodule