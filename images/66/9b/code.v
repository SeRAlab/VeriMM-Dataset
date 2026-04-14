module top_module(
    input A,
    input B,
    input C,
    output X
);wire notA;
    wire notB;
    wire notC;
    wire andAB;
    wire andBC;
    wire andCA;
    wire orABC;

    assign notA = ~A;
    assign notB = ~B;
    assign notC = ~C;

    assign andAB = A & B;
    assign andBC = B & C;
    assign andCA = C & A;

    assign orABC = andAB | andBC | andCA;

    assign X = ~orABC;

endmodule