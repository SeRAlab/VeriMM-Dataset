module carry_save_adder (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [4:0] S
);
    wire [4:0] sum_ab, sum_abc;
    wire [4:0] carry_ab, carry_abc;

    assign sum_ab = A + B;  // Sum of A and B
    assign carry_ab = {1'b0, sum_ab[4]} + {1'b0, sum_ab[3:0]} + C; // Carry and sum with C
    assign sum_abc = sum_ab + C;

    assign S = sum_abc; // Output the final sum result
endmodule