module top_module(
    A,
    B,
    X
);input A;
    input B;
    output X;

    // Replace the unknown module with a standard OR gate for portability
    assign X = A | B;

endmodule