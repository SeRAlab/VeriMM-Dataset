module top_module(c, o);input [4:0] c;
    output o;
    assign o = c[3] & (c[2] | c[1]) | c[4];endmodule