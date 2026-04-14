module carry_save_adder (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [4:0] S,
    output [3:0] C_out
);
    wire [4:0] sum1, sum2;
    
    // First stage: Add A and B
    assign sum1 = A + B;

    // Second stage: Add sum1 and C
    assign S = sum1 + C;

    // Calculate carry output
    assign C_out = (sum1[4] | (sum1[3] & sum1[2])) ? 4'b0001 : 4'b0000;

endmodule