module wallace_tree_multiplier(
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] pp[3:0]; // partial products
    wire [6:0] s[2:0]; // sums for reduction
    wire [6:0] c[2:0]; // carries for reduction

    // Generate partial products
    assign pp[0] = A & {4{B[0]}};
    assign pp[1] = A & {4{B[1]}};
    assign pp[2] = A & {4{B[2]}};
    assign pp[3] = A & {4{B[3]}};

    // First reduction layer (stage 1)
    assign s[0][0] = pp[0][0];
    assign s[0][1] = pp[0][1] ^ pp[1][0];
    assign s[0][2] = pp[0][2] ^ pp[1][1] ^ pp[2][0];
    assign s[0][3] = pp[0][3] ^ pp[1][2] ^ pp[2][1];
    assign s[0][4] = pp[1][3] ^ pp[2][2];
    assign s[0][5] = pp[2][3];
    
    assign c[0][0] = 0; // no carry from bit 0
    assign c[0][1] = pp[1][0] & pp[0][1];
    assign c[0][2] = (pp[1][1] & pp[0][2]) | (pp[2][0] & pp[1][1]);
    assign c[0][3] = (pp[1][2] & pp[0][3]) | (pp[2][1] & pp[1][2]);
    assign c[0][4] = pp[2][2] & pp[1][3];

    // Second reduction layer (stage 2)
    assign s[1][0] = s[0][0] ^ c[0][0];
    assign s[1][1] = s[0][1] ^ c[0][1];
    assign s[1][2] = s[0][2] ^ c[0][2];
    assign s[1][3] = s[0][3] ^ c[0][3];
    assign s[1][4] = s[0][4] ^ c[0][4];
    assign s[1][5] = s[0][5];

    assign c[1][0] = 0; // no carry from bit 0
    assign c[1][1] = pp[2][0] & pp[1][1];
    assign c[1][2] = pp[2][1] & pp[1][2];
    assign c[1][3] = pp[2][2] & pp[1][3];

    // Final addition to get the result
    assign P[0] = s[1][0];
    assign P[1] = s[1][1];
    assign P[2] = s[1][2] ^ c[1][1];
    assign P[3] = s[1][3] ^ c[1][2];
    assign P[4] = s[1][4] ^ c[1][3];
    assign P[5] = s[1][5];
    assign P[6] = 0; // no overflow
    assign P[7] = 0; // no overflow

endmodule