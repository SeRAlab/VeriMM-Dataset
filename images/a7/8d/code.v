module top_module(
    input[3:0] g,
    input[3:0] p,
    input c,
    output P,
    output G,
    output C3,
    output C2,
    output C1,
    output C0
    );assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign P = p[3] & p[2] & p[1] & p[0];
    assign C0 = g[0] | (p[0] & c);
    assign C1 = g[1] | (p[1] & g[0]) |  (p[1] & p[0] & c);
    assign C2 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c);
    assign C3 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] &c);
endmodule