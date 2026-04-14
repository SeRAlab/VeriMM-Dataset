module brent_kung_adder (
    input [4:0] a,
    input [4:0] b,
    output [5:0] sum
);
    wire [4:0] p, g, c;

    // Generate propagate and generate signals
    assign p = a ^ b; // Propagate
    assign g = a & b; // Generate

    // Carry generation using Brent-Kung logic
    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & g[0]);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
    assign c[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign c[4] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & g[0]);

    // Sum calculation
    assign sum = {c[4], p} ^ {1'b0, c}; // Final sum output

endmodule