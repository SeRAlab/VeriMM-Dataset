module top_module(
    Y,
    A,
    B,
    S
);output Y;
    input A;
    input B;
    input S;

    assign Y = (S) ? B : A;

endmodule