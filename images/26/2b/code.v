module qr_decomposition (
    input [3:0] A, // A[3:2] A[1:0] for row 1 and row 2 respectively
    output reg [3:0] Q, // Q[3:2] Q[1:0]
    output reg [3:0] R  // R[3:2] R[1:0]
);

    wire [3:0] a1, a2;
    assign a1 = A[3:2]; // First row
    assign a2 = A[1:0]; // Second row

    always @(*) begin
        // Compute norm of first column (R[0,0])
        R[3:2] = a1; // R[0,0] = a1
        R[1:0] = 4'b0000; // R[0,1] = 0 for simplicity

        // Compute Q
        // Normalize first column
        Q[3:2] = a1; // Q[0] = a1
        Q[1:0] = 4'b0000; // Q[1] = 0 for simplicity

        // Compute projection and update second column
        Q[3:2] = Q[3:2] / (R[3:2] == 0 ? 1 : R[3:2]); // Normalize Q if R not zero
        // Assume simple case where second column is orthogonal for demo
        Q[1:0] = a2; // Q[1] = a2
    end
endmodule