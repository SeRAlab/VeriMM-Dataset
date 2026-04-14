module top_module(g, p, G1, Pr1);input [31:0]g;
    input [31:0]p;
    output [31:0]G1;
    output [31:0]Pr1;

    assign G1[31:0] = g[31:0] | p[31:0] & {g[30:0],g[31]} ;
    assign Pr1[31:0] = p[31:0] & {p[30:0],p[31]} ;endmodule