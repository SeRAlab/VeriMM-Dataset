module csa_4bit (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [3:0] S,
    output [3:0] Cout
);
    wire [4:0] partial_sum;
    wire [4:0] partial_carry;

    // Compute partial sums and carries
    assign partial_sum = A + B;
    assign partial_carry = {1'b0, C} + partial_sum;

    // Final outputs
    assign S = partial_carry[3:0];
    assign Cout = partial_carry[4:1];

endmodule