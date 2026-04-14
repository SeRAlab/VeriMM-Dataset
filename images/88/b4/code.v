module top_module(
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    output Y
);wire w1, w2, w3;

    assign w1 = (~S1 & ~S0) ? A : (~S1 & S0) ? B : (S1 & ~S0) ? C : D;
    assign w2 = (S1 & ~S0) ? C : D;
    assign w3 = (S1 & S0) ? D : w2;

    assign Y = (S1 & S0) ? w1 : w3;

endmodule