module top_module(
    input A, B, C, D,
    input S0, S1,
    output Y
);wire w1, w2, w3;

// First level of multiplexing
assign w1 = (S0 == 0 && S1 == 0) ? A : B;
assign w2 = (S0 == 1 && S1 == 0) ? C : D;

// Second level of multiplexing
assign w3 = (S1 == 1) ? w2 : w1;

// Output
assign Y = w3;

endmodule