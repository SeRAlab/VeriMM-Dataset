module top_module(
    A,
    B,
    S,
    Y
);input A;
    input B;
    input S;
    output Y;

    assign Y = (S == 0) ? A : B;

endmodule