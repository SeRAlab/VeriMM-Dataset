module top_module(
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    output Y
);wire w1, w2, w3, w4;

    assign w1 = (S1 & S0) ? D : 1'b0;
    assign w2 = (S1 & ~S0) ? C : 1'b0;
    assign w3 = (~S1 & S0) ? B : 1'b0;
    assign w4 = (~S1 & ~S0) ? A : 1'b0;

    assign Y = w1 | w2 | w3 | w4;

endmodule