module wallace_tree_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] partial [3:0];
    
    // Generate partial products
    assign partial[0] = A & {4{B[0]}};
    assign partial[1] = A & {4{B[1]}};
    assign partial[2] = A & {4{B[2]}};
    assign partial[3] = A & {4{B[3]}};
    
    // Structure for Wallace Tree Reduction
    wire [4:0] sum1, sum2, sum3, carry1, carry2;
    
    // First stage of addition
    assign sum1 = partial[0] + {1'b0, partial[1][3:1]};
    assign carry1 = {1'b0, partial[1][0]} + partial[2];
    
    // Second stage of addition
    assign sum2 = sum1 + carry1[3:1];
    assign carry2 = carry1[0] + partial[3];
    
    // Final stage
    assign P = {carry2[3:1], sum2} + {carry2[0], 4'b0000};
    
endmodule