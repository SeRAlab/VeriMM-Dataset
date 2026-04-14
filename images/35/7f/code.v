module carry_save_adder (
    input [2:0] A,
    input [2:0] B,
    input [2:0] C,
    output [3:0] S,
    output [2:0] C_out
);

    wire [3:0] sum_ab, sum_abc;
    wire [2:0] carry_ab, carry_abc;

    // Intermediate sums and carries
    assign sum_ab = A + B;
    assign carry_ab = {1'b0, sum_ab[3]} + C; // Adding C to the carry of the sum_ab
    assign sum_abc = sum_ab + {1'b0, carry_ab}; // Final sum

    // Output assignments
    assign S = sum_abc;
    assign C_out = carry_ab;

endmodule