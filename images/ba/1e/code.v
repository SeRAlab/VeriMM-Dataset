module top_module(
    input [3:0] A,
    input [1:0] S,
    output X
);// Intermediate wires for each selection
    wire w0, w1, w2, w3;

    // Assign outputs based on the selection lines
    assign w0 = ~S[0] & ~S[1] & A[0];  // When S = 00, select A[0]
    assign w1 = ~S[0] & S[1] & A[1];   // When S = 01, select A[1]
    assign w2 = S[0] & ~S[1] & A[2];    // When S = 10, select A[2]
    assign w3 = S[0] & S[1] & A[3];     // When S = 11, select A[3]

    // Final output is the logical OR of the selected inputs
    assign X = w0 | w1 | w2 | w3;

endmodule