module top_module(
    A,
    B,
    C,
    D,
    S0,
    S1,
    Y
);input A, B, C, D, S0, S1;
output Y;

wire w1, w2, w3;

and #(1) and1(w1, A, ~S0, ~S1);
and #(1) and2(w2, B, S0, ~S1);
and #(1) and3(w3, C, ~S0, S1);

or #(1) or1(Y, w1, w2, w3, D);

endmodule