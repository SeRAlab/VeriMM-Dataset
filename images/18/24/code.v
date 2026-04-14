module wallace_tree_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire [7:0] pp [3:0]; // Partial products
    wire [7:0] sum1, sum2, carry1, carry2;
    
    // Generate partial products
    assign pp[0] = {4'b0000, A & {4{B[0]}}};
    assign pp[1] = {3'b000, A & {4{B[1]}}, 1'b0};
    assign pp[2] = {2'b00, A & {4{B[2]}}, 2'b00};
    assign pp[3] = {1'b0, A & {4{B[3]}}, 3'b000};
    
    // First stage of reduction
    assign {carry1[0], sum1[0]} = pp[0][0] + pp[1][0] + pp[2][0];
    assign {carry1[1], sum1[1]} = pp[0][1] + pp[1][1] + pp[2][1];
    assign {carry1[2], sum1[2]} = pp[0][2] + pp[1][2] + pp[2][2];
    assign {carry1[3], sum1[3]} = pp[0][3] + pp[1][3] + pp[2][3];
    assign {carry1[4], sum1[4]} = pp[0][4] + pp[1][4] + pp[2][4];
    assign {carry1[5], sum1[5]} = pp[0][5] + pp[1][5] + pp[2][5];
    assign {carry1[6], sum1[6]} = pp[0][6] + pp[1][6] + pp[2][6];
    assign {carry1[7], sum1[7]} = pp[0][7] + pp[1][7] + pp[2][7];
    
    // Second stage of reduction
    assign {carry2[0], sum2[0]} = sum1[0] + pp[3][0] + carry1[0];
    assign {carry2[1], sum2[1]} = sum1[1] + pp[3][1] + carry1[1];
    assign {carry2[2], sum2[2]} = sum1[2] + pp[3][2] + carry1[2];
    assign {carry2[3], sum2[3]} = sum1[3] + pp[3][3] + carry1[3];
    assign {carry2[4], sum2[4]} = sum1[4] + pp[3][4] + carry1[4];
    assign {carry2[5], sum2[5]} = sum1[5] + pp[3][5] + carry1[5];
    assign {carry2[6], sum2[6]} = sum1[6] + pp[3][6] + carry1[6];
    assign {carry2[7], sum2[7]} = sum1[7] + pp[3][7] + carry1[7];
    
    // Final output
    assign P = sum2 + carry2;

endmodule