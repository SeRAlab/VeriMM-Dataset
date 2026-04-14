module nand4 (
    input A,
    input B,
    input C,
    input D,
    output Y
);

wire AB, CD, ABCD;
not (AB, A & B);
not (CD, C & D);
not (ABCD, AB & CD);
not (Y, ABCD);

endmodule