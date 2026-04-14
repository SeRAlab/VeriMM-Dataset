module carry_save_adder (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [4:0] SUM,
    output [3:0] CARRY
);
    wire [4:0] partial_sum1;
    wire [4:0] partial_sum2;

    // Compute partial sums
    assign partial_sum1 = {1'b0, A} + {1'b0, B};
    assign partial_sum2 = partial_sum1 + {1'b0, C};

    // Assign outputs
    assign SUM = partial_sum2[4:0]; // 5-bit sum
    assign CARRY = partial_sum2[4:1]; // 4-bit carry
endmodule