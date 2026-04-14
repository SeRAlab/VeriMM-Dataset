module top_module(
    A,
    B,
    C,
    S,
    OVF
);input [3:0] A;
    input [3:0] B;
    input C;
    output [3:0] S;
    output OVF;

    wire [3:0] B_neg;
    wire [3:0] C_neg;
    wire [3:0] B_neg_plus_1;
    wire [3:0] B_minus_C;
    wire [3:0] A_plus_B;
    wire [3:0] A_minus_B;

    assign B_neg = ~B + 1;
    assign C_neg = ~C + 1;
    assign B_neg_plus_1 = B_neg + 1;
    assign B_minus_C = B + C_neg;
    assign A_plus_B = A + B;
    assign A_minus_B = A + B_neg;

    assign S = (C == 0) ? A_plus_B : A_minus_B;
    assign OVF = (C == 0) ? ((A_plus_B[3] == 1 && B[3] == 1 && S[3] == 0) || (A_plus_B[3] == 0 && B[3] == 0 && S[3] == 1)) : ((A_minus_B[3] == 1 && B_neg[3] == 1 && S[3] == 0) || (A_minus_B[3] == 0 && B_neg[3] == 0 && S[3] == 1));

endmodule