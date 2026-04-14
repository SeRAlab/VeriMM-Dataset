module wallace_tree_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] pp [3:0]; // partial products
    wire [4:0] s1, s2; // sums for Wallace tree reduction
    wire [3:0] c1, c2; // carries for Wallace tree reduction

    // Generate partial products
    assign pp[0] = A & {4{B[0]}};
    assign pp[1] = A & {4{B[1]}};
    assign pp[2] = A & {4{B[2]}};
    assign pp[3] = A & {4{B[3]}};

    // First stage of reduction
    // Sum and carry for the first three bits
    assign s1 = pp[0][0] + pp[1][0] + pp[2][0];
    assign c1[0] = (pp[0][0] & pp[1][0]) | (pp[0][0] & pp[2][0]) | (pp[1][0] & pp[2][0]);
    
    // Repeat for the second bits
    assign s1[1] = pp[0][1] + pp[1][1] + pp[2][1];
    assign c1[1] = (pp[0][1] & pp[1][1]) | (pp[0][1] & pp[2][1]) | (pp[1][1] & pp[2][1]);

    // Repeat for the third bits
    assign s1[2] = pp[0][2] + pp[1][2] + pp[2][2];
    assign c1[2] = (pp[0][2] & pp[1][2]) | (pp[0][2] & pp[2][2]) | (pp[1][2] & pp[2][2]);

    // Handle final bit separately
    assign s1[3] = pp[0][3] + pp[1][3] + pp[2][3] + c1[0];
    assign c1[3] = (pp[0][3] & pp[1][3]) | (pp[0][3] & pp[2][3]) | (pp[1][3] & pp[2][3]);

    // Second stage of reduction
    assign s2[0] = s1[0] + c1[1];
    assign c2[0] = (s1[0] & c1[1]);

    assign s2[1] = s1[1] + c1[2];
    assign c2[1] = (s1[1] & c1[2]);

    // Final output
    assign P = {s1[3] + c2[0], s2[0], s2[1], s1[2]};

endmodule