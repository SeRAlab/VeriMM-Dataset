module two_to_one_mux (
    A,
    B,
    S,
    Y
);

    input A;
    input B;
    input S;
    output Y;

    assign Y = (S == 0) ? A : B;

endmodule