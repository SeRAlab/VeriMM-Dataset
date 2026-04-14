module top_module(a, b, c);input [3:0] a, b;
    output [2:0] c;
    wire [3:0] x;

    assign x = ~(((~a) & b) | (a & (~b)));
    assign c[2] = x[0] & x[1] & x[2] & x[3];
    assign c[1] = (a[3] & ~b[3]) | (x[3] & a[2] & ~b[2]) | (x[3] & x[2] & a[1] & ~b[1]) | (x[3] & x[2] & x[1] & a[0] & ~b[0]);
    assign c[0] = !(c[1] | c[2]);endmodule