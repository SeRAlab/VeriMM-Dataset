module top_module(
    X,
    A,
    SLEEP
);output X;
    input A;
    input SLEEP;

    wire signal1, signal2, signal3, signal4;

    assign signal1 = A & SLEEP;
    assign signal2 = ~SLEEP;
    assign signal3 = A;
    assign signal4 = SLEEP;

    assign X = (SLEEP) ? (signal1 & signal2) | (signal3 & signal4) : A;

endmodule