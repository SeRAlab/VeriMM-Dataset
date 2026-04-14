module carry_save_adder(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [3:0] sum,
    output [1:0] carry
);
    wire [4:0] partial_sum_1;
    wire [4:0] partial_sum_2;

    // Intermediate sums
    assign partial_sum_1 = A + B; // 5-bit to accommodate carry
    assign partial_sum_2 = partial_sum_1 + C;

    // Final sum and carry
    assign sum = partial_sum_2[3:0];
    assign carry = partial_sum_2[4:3];
endmodule