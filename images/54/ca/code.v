module top_module(
    A1,
    A2,
    A3,
    B1,
    X
);input A1;
    input A2;
    input A3;
    input B1;
    output X;

    wire and1;
    wire and2;
    wire and3;

    assign and1 = A1 & A2;
    assign and2 = A2 & A3;
    assign and3 = and2 & B1;

    assign X = and1 | and3;

endmodule