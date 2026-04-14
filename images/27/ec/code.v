module wallace_multiplier(
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [3:0] prod [3:0];
    
    // Generate partial products
    assign prod[0] = A & {4{B[0]}};
    assign prod[1] = A & {4{B[1]}};
    assign prod[2] = A & {4{B[2]}};
    assign prod[3] = A & {4{B[3]}};

    wire [3:0] sum1, sum2, carry1, carry2;
    
    // First stage: Sum and carry
    assign {carry1, sum1} = prod[0] + prod[1];
    assign {carry2, sum2} = prod[2] + prod[3];
    
    // Second stage: Sum the carry and sums
    wire [4:0] final_sum;
    assign final_sum = {1'b0, sum1} + sum2 + carry1;

    assign P = final_sum; // Output the final product
endmodule