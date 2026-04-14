module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    output X
);// Define intermediate signals
    wire w1, w2, w3;

    // Implement XOR gates
    assign w1 = A1 ^ A2;
    assign w2 = B1 ^ B2;

    // Implement AND gates
    assign w3 = w1 & w2;

    // Implement final XOR gate
    assign X = w3 ^ A2;

endmodule