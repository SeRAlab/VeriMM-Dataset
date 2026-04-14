module wallace_tree_adder (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [4:0] S
);
    wire [3:0] P0, P1, P2;
    wire [4:0] S1, S2;

    // Partial products
    assign P0 = A & {4{B[0]}};
    assign P1 = A & {4{B[1]}};
    assign P2 = A & {4{B[2]}};

    // First stage of Wallace tree
    wire [3:0] W0, W1, W2;
    assign W0 = P0;
    assign W1 = P1 ^ {1'b0, P1[3:1]};
    assign W2 = P2 ^ {2'b0, P2[3:2]};

    // Carry calculation
    wire c1, c2;
    assign S1 = W1 + {1'b0, W0}; // First partial sum
    assign c1 = S1[4]; // Carry out from first sum
    assign S2 = W2 + S1[3:0]; // Second partial sum with carry

    // Final sum
    assign S = {c1, S2[3:0]};
endmodule