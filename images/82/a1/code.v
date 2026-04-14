module top_module(
    input [3:0] A, B, C, D,
    input S0, S1,
    output Y
);wire w1, w2;

assign w1 = (S1 & ~S0) ? C : D;
assign w2 = (S1 & S0) ? B : A;
assign Y = (S1 | S0) ? w1 : w2;

endmodule