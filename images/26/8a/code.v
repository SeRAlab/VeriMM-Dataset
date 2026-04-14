module qr_decomposition (
    input [3:0] a,  // Row 1 of the matrix
    input [3:0] b,  // Row 2 of the matrix
    output reg [3:0] q1,  // Q matrix first column
    output reg [3:0] q2,  // Q matrix second column
    output reg [3:0] r11,  // R matrix element
    output reg [3:0] r12,  // R matrix element
    output reg [3:0] r22   // R matrix element
);

always @(*) begin
    // Calculate the norms
    q1 = a; // First column of Q is just the first row
    r11 = (q1 * q1) ** 0.5; // Calculate the norm of q1
    q1 = q1 / r11; // Normalize q1

    // Calculate second column of Q
    r12 = (q1 * b) / r11; // Projection of b onto q1
    q2 = b - r12 * q1; // Orthogonal component
    r22 = (q2 * q2) ** 0.5; // Calculate the norm of q2
    q2 = q2 / r22; // Normalize q2

    // Fill R matrix
    r11 = r11;
    r12 = r12;
    r22 = r22;
end

endmodule