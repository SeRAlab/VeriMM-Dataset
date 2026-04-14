module matrix_factorization (
    input [7:0] U00, U01, U10, U11, // User features matrix
    input [7:0] V00, V01, V10, V11, // Item features matrix
    output [15:0] R00, R01, R10, R11 // Predicted ratings matrix
);
    assign R00 = U00 * V00 + U01 * V10; // R[0,0] = U[0,0]*V[0,0] + U[0,1]*V[1,0]
    assign R01 = U00 * V01 + U01 * V11; // R[0,1] = U[0,0]*V[0,1] + U[0,1]*V[1,1]
    assign R10 = U10 * V00 + U11 * V10; // R[1,0] = U[1,0]*V[0,0] + U[1,1]*V[1,0]
    assign R11 = U10 * V01 + U11 * V11; // R[1,1] = U[1,0]*V[0,1] + U[1,1]*V[1,1]
endmodule