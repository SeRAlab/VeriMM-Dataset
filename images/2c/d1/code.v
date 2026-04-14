module carry_save_adder(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [4:0] S,
    output [3:0] Cout
);
    wire [3:0] sum1, carry1, sum2, carry2;

    // First stage of addition
    assign sum1 = A ^ B;      // Sum of A and B
    assign carry1 = A & B;    // Carry of A and B

    // Second stage of addition
    assign sum2 = sum1 ^ C;   // Sum of previous sum with C
    assign carry2 = sum1 & C; // Carry of previous sum with C

    // Final outputs
    assign S = sum2;
    assign Cout = carry1 | carry2; // Combine carries

endmodule