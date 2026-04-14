module QR_decomposition (
    input [15:0] A, // 2x2 matrix input
    output reg [15:0] Q, // Orthogonal matrix output
    output reg [15:0] R // Upper triangular matrix output
);
    wire signed [15:0] a11, a12, a21, a22;
    assign {a11, a12, a21, a22} = A;

    reg signed [15:0] r11, r12, r21, r22;
    reg signed [15:0] q1, q2;

    always @(*) begin
        // Compute R
        r11 = a11;
        r12 = a12;
        r21 = (a21 * r11) / r11; // Simplified for fixed-point
        r22 = a22 - (r21 * r12 / r11); // Simplified for fixed-point

        // Compute Q
        q1 = r11; // Normalize first vector
        q2 = a21 - (r21 * q1 / r11); // Orthogonalization
        
        // Assign outputs
        Q = {q1, q2};
        R = {r11, r12, r21, r22};
    end
endmodule