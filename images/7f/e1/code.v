module top_module(
    A,
    B,
    C,
    D,
    X
);input [3:0] A, B, C, D;
    output X;

    wire or1, or2, or3;
    
    // Assuming the basic OR gate definition since the specific module is unknown
    // Replacing the unknown module reference with a basic OR gate function implementation
    assign or1 = A[0] | B[0] | C[0] | D[0];
    assign or2 = A[1] | B[1] | C[1] | D[1];
    assign or3 = A[2] | B[2] | C[2] | D[2];

    // Final OR gate incorporating the fourth input D[3]
    assign X = or1 | or2 | or3 | D[3];

endmodule