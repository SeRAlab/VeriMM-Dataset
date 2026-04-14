module wallace_tree_adder (
    input [3:0] A,
    input [3:0] B,
    output [4:0] SUM
);
    wire [3:0] p; // Partial products
    wire [4:0] s; // Intermediate sums

    assign p = A & {4{B}}; // Generate partial products

    // First stage of reduction
    assign s[0] = p[0]; // First bit remains the same
    assign s[1] = p[1] ^ p[2]; // Sum of bit 1 and 2
    assign s[2] = (p[1] & p[2]); // Carry out for bit 1 and 2
    assign s[3] = p[3] ^ s[2]; // Sum of current bit and carry
    assign s[4] = p[3] & s[2]; // Final carry out

    // Final sum output
    assign SUM = {s[4], s[3], s[1], s[0]}; // Concatenate final outputs
endmodule