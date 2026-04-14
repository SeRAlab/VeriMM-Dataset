module lu_decomposition (
    input [7:0] a11, a12, a21, a22,
    output reg [7:0] l11, l12, l21, l22,
    output reg [7:0] u11, u12, u21, u22
);
    
    always @(*) begin
        // Upper triangular matrix U
        u11 = a11;
        u12 = a12;
        u21 = a21; 
        u22 = a22 - (a21 * a12) / a11; // U22 = A22 - L21 * U12
        
        // Lower triangular matrix L
        l11 = 8'd1; // L11 is always 1
        l12 = 8'd0; // L12 is always 0
        l21 = a21 / a11; // L21 = A21 / U11
        l22 = 8'd1; // L22 is always 1
    end
endmodule