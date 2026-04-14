module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);wire [4:0] c; // Carry wires
    wire [3:0] g; // Generate signals
    wire [3:0] p; // Propagate signals

    assign g = a ^ b; // Generate signal (XOR)
    assign p = a & b; // Propagate signal (AND)

    assign c[0] = cin; // Initial carry-in
    assign c[1] = p[0] | (g[0] & c[0]); // Carry out for bit 1
    assign c[2] = p[1] | (g[1] & c[1]); // Carry out for bit 2
    assign c[3] = p[2] | (g[2] & c[2]); // Carry out for bit 3
    assign c[4] = p[3] | (g[3] & c[3]); // Final carry out

    assign sum = g ^ {c[3:1], c[0]}; // Sum calculation using XOR with carry
    assign cout = c[4]; // Final carry out

endmodule