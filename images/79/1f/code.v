module top_module(
    input [3:0] A, B, C, D,
    input [1:0] S,
    output Y
);wire w1, w2, w3, w4, w5, w6;

    and (w1, A, ~S[1]);
    and (w2, B, S[1]);
    and (w3, C, ~S[0]);
    and (w4, D, S[0]);

    or (w5, w1, w2);
    or (w6, w3, w4);

    or (Y, w5, w6);

endmodule