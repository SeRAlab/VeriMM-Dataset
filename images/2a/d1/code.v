module qr_decomposition (
    input [1:0] a, // First element of matrix
    input [1:0] b, // Second element of matrix
    input [1:0] c, // Third element of matrix
    input [1:0] d, // Fourth element of matrix
    output [1:0] q11, // Q matrix element
    output [1:0] q12, // Q matrix element
    output [1:0] r11, // R matrix element
    output [1:0] r12, // R matrix element
    output [1:0] r22  // R matrix element
);

    wire [3:0] r; // Intermediate wire for calculations
    assign r11 = a; // R11 = a
    assign r12 = b; // R12 = b
    assign r22 = c; // R22 = c

    // Calculate Q matrix using the simplified method
    assign q11 = (r11 == 0) ? 0 : a / r11; // Q11 = A11 / R11
    assign q12 = (r12 == 0) ? 0 : b / r12; // Q12 = A12 / R12

endmodule