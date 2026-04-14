module and_4 (
    input A,
    input B,
    input C,
    input D,
    output Y
);

    wire AB, CD, ABCD;
    and gate1(AB, A, B);
    and gate2(CD, C, D);
    not gate3(CD_not, CD);
    and gate4(ABCD, AB, CD_not);
    assign Y = ABCD;

endmodule