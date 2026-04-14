module carry_save_adder(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [4:0] S,
    output [4:0] C_out
);
    wire [4:0] sum_AB, sum_ABC;
    wire [4:0] carry_AB, carry_ABC;

    // Intermediate sum and carry for A and B
    assign sum_AB = A ^ B; // Sum of A and B
    assign carry_AB = A & B; // Carry of A and B

    // Intermediate sum and carry for (sum_AB + C)
    assign sum_ABC = sum_AB ^ C; // Final Sum
    assign carry_ABC = carry_AB | (sum_AB & C); // Final Carry

    assign S = sum_ABC; // Sum output
    assign C_out = carry_ABC; // Carry output
endmodule