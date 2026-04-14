module carry_save_adder (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [4:0] Sum,
    output [3:0] Carry
);
    wire [3:0] sum_ab, sum_ac, sum_bc;
    wire [3:0] carry_ab, carry_ac, carry_bc;

    // First stage: add A and B
    assign sum_ab = A ^ B;
    assign carry_ab = A & B;

    // Second stage: add sum_ab with C
    assign sum_ac = sum_ab ^ C;
    assign carry_ac = sum_ab & C;

    // Final stage: combine carries
    assign Sum = sum_ac ^ carry_ab;
    assign Carry = carry_ab | carry_ac;
endmodule