module my_module (
    X,
    A1,
    A2,
    A3,
    B1
);

    output X;
    input A1;
    input A2;
    input A3;
    input B1;

    assign X = ((A1 & ~A2) | (A2 & ~A1 & A3 & ~B1) | (~A1 & ~A2 & ~A3 & B1)) ? 1'b1 : 1'b0;

endmodule