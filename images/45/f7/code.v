module top_module(
    input  A,
    input  B,
    input  C,
    output X
);wire  A_xor_B;
    wire  A_or_B;

    assign A_xor_B = A ^ B;
    assign A_or_B  = A | B;

    assign X = (C == 1'b1) ? A_xor_B : A_or_B;

endmodule