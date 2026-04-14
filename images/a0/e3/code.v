module top_module(
    Y,
    A,
    B,
    C,
    D
);output Y;
    input A;
    input B;
    input C;
    input D;

    wire w1, w2, w3;

    // Assuming a correct nor4 implementation here instead of missing module
    wire nA, nB, nC, nD;
    not (nA, A);
    not (nB, B);
    not (nC, C);
    not (nD, D);
    
    // Create a 4-input NOR gate using previously defined NOT gates
    assign w1 = ~(A | B | C | nD);
    assign w2 = ~(w1 | w1 | w1 | w1);
    assign w3 = ~(w2 | w2 | w2 | w2);
    
    assign Y = ~w3;

endmodule