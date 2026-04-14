module QR_Decomposition (
    input [15:0] A, // Input matrix (A[15:12], A[11:8], A[7:4], A[3:0])
    output reg [15:0] Q, // Output Q matrix
    output reg [15:0] R  // Output R matrix
);
    wire signed [15:0] a11, a12, a21, a22;
    wire signed [15:0] r11, r12, r21, r22;
    wire signed [15:0] q11, q12, q21, q22;
    
    assign a11 = A[15:12]; // Row 1, Col 1
    assign a12 = A[11:8];  // Row 1, Col 2
    assign a21 = A[7:4];   // Row 2, Col 1
    assign a22 = A[3:0];   // Row 2, Col 2

    // Calculate R
    assign r11 = a11;
    assign r12 = a12;
    assign r21 = ((a21 * a11) / r11); // r21 = a21 * q11
    assign r22 = a22 - r21 * (a12 / r11); // r22 = a22 - (r21 * (a12 / r11))

    // Calculate Q
    assign q11 = r11 ? (a11 / r11) : 0; // q11 = a11 / r11
    assign q12 = r12 ? (a12 / r11) : 0; // q12 = a12 / r11
    assign q21 = a21 ? (a21 / r21) : 0; // q21 = a21 / r21
    assign q22 = r22 ? (a22 / r22) : 0; // q22 = a22 / r22

    always @(*) begin
        Q = {q11, q12, q21, q22}; // Output Q matrix
        R = {r11, r12, r21, r22}; // Output R matrix
    end
endmodule