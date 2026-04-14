module brent_kung_adder (
    input [3:0] a,
    input [3:0] b,
    output [3:0] sum,
    output carry_out
);
    wire [3:0] p; // propagate
    wire [3:0] g; // generate
    wire [3:0] c; // carry

    // Calculate propagate and generate
    assign p = a ^ b; // propagate
    assign g = a & b; // generate

    // Carry calculation using Brent-Kung logic
    assign c[0] = 0; // Initial carry-in is 0
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

    // Sum calculation
    assign sum = p ^ c[3:0]; // Sum bits

    // Carry out
    assign carry_out = c[3];

endmodule