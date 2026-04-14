module top_module(
    A,
    B,
    C,
    D,
    X
);input A;
    input B;
    input C;
    input D;
    output X;

    wire AB;
    wire CD;
    wire ABCD;

    // Use standard XOR gates or define your own `xor3` functionality if external module isn't available
    // Here we will use a standard XOR gate implementation (2-input)

    assign AB = A ^ B;          // A XOR B
    assign CD = C ^ D;          // C XOR D
    assign ABCD = AB ^ CD;      // (A XOR B) XOR (C XOR D)
    assign X = ABCD;            // Final output

endmodule