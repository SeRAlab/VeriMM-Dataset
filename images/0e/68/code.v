module brent_kung_adder (
    input [4:0] a,
    input [4:0] b,
    input cin,
    output [5:0] sum,
    output cout
);
    wire [4:0] p, g; // propagate and generate
    wire [4:0] c;    // carry signals

    assign p = a ^ b; // propagate
    assign g = a & b; // generate

    // Carry generation
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & p[0] & c[0]);
    assign cout = g[4] | (p[4] & c[4]);

    // Sum generation
    assign sum = p ^ {c[4:0], cin};

endmodule