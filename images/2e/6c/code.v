module csa_4bit (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [4:0] S,
    output [3:0] Cout
);
    wire [3:0] sum_ab, sum_ac, sum_bc;
    wire [3:0] carry_ab, carry_ac, carry_bc;

    // Partial sums
    assign sum_ab = A ^ B; // Sum of A and B
    assign carry_ab = A & B; // Carry of A and B

    assign sum_ac = sum_ab ^ C; // Sum of (A + B) and C
    assign carry_ac = sum_ab & C; // Carry of ((A + B) + C)

    // Final sum and carry
    assign S = sum_ac ^ carry_ab; // Final sum
    assign Cout = {carry_ac, carry_ab} | (carry_ac << 1); // Final carry

endmodule