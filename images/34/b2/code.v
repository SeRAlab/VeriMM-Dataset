module LU_Decomposition (
    input [7:0] a11, a12, 
    input [7:0] a21, a22,
    output reg [7:0] l11, l12, l21, l22,
    output reg [7:0] u11, u12, u21, u22
);

always @(*) begin
    // Initialize L and U
    l11 = 8'd1; // L(1,1) = 1
    l12 = 8'd0; // L(1,2) = 0
    l21 = a21 / a11; // L(2,1) = A(2,1) / A(1,1)
    l22 = 8'd1; // L(2,2) = 1 (for 2x2 matrix)

    u11 = a11; // U(1,1) = A(1,1)
    u12 = a12; // U(1,2) = A(1,2)
    u21 = 8'd0; // U(2,1) = 0 (since we want upper triangular)
    u22 = a22 - (l21 * u12); // U(2,2) = A(2,2) - L(2,1)*U(1,2)
end

endmodule