module lu_decomposition (
    input [7:0] a11, a12, 
    input [7:0] a21, a22, 
    output reg [7:0] l11, l12, l21, l22, 
    output reg [7:0] u11, u12, u21, u22
);
    always @(*) begin
        // LU Decomposition for 2x2 matrix
        l11 = a11;            // Lower triangular L
        l12 = 0;              // L's upper row will be 0
        l21 = a21 / a11;     // L's lower row values
        l22 = 0;              // L's lower row will be 0

        u11 = a11;            // Upper triangular U
        u12 = a12;           // U's upper row values
        u21 = 0;              // U's lower row will be 0
        u22 = a22 - (l21 * u12); // Calculate U's lower row value
    end
endmodule