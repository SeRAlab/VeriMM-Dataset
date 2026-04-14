module wallace_tree_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] pp[3:0]; // Partial products

    // Generate partial products
    assign pp[0] = A & {4{B[0]}};
    assign pp[1] = A & {4{B[1]}};
    assign pp[2] = A & {4{B[2]}};
    assign pp[3] = A & {4{B[3]}};

    // Level 1: Add the first two partial products
    wire [4:0] sum1;
    wire carry1;
    assign {carry1, sum1} = pp[0] + pp[1];

    // Level 2: Add the next partial product and the sum
    wire [4:0] sum2;
    wire carry2;
    assign {carry2, sum2} = sum1 + pp[2];

    // Level 3: Final addition of the last partial product
    assign P = sum2 + {carry1, sum2[3:0]} + pp[3];

endmodule