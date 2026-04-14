module wallace_tree_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] partial_products[3:0];
    wire [7:0] sum1, sum2, sum3;
    wire [3:0] carry1, carry2;
    
    // Generate partial products
    assign partial_products[0] = A & {4{B[0]}};
    assign partial_products[1] = A & {4{B[1]}};
    assign partial_products[2] = A & {4{B[2]}};
    assign partial_products[3] = A & {4{B[3]}};
    
    // First reduction stage
    assign sum1 = partial_products[0] + {partial_products[1][3:0], 1'b0};
    assign sum2 = {1'b0, partial_products[2]} + {2'b0, partial_products[3][3:1]};
    
    // Second reduction stage
    assign {carry1, sum3} = sum1 + sum2;
    
    // Final addition
    assign P = sum3 + {carry1, 4'b0000};
    
endmodule