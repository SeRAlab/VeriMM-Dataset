module and3(
    X,
    A,
    B,
    C
);

    output X;
    input A;
    input B;
    input C;

    wire AB;
    wire ABC;

    assign AB = A & B;
    assign ABC = AB & C;
    assign X = ABC;

endmodule