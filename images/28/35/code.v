module wallace_tree_multiplier(
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] partial_product0 = A & {4{B[0]}};
    wire [3:0] partial_product1 = A & {4{B[1]}};
    wire [3:0] partial_product2 = A & {4{B[2]}};
    wire [3:0] partial_product3 = A & {4{B[3]}};

    wire [5:0] s0, s1, s2;
    wire c0, c1, c2;

    // First level of addition
    assign {c0, s0} = partial_product0 + (partial_product1 << 1);
    assign {c1, s1} = partial_product2 + (partial_product3 << 2);
    
    // Second level of addition
    assign {c2, s2} = s0 + s1;

    // Final result
    assign P = {c2, s2} + {2'b0, c0}; // Combine all parts together

endmodule