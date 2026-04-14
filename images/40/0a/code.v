module LU_Decomposition (
    input [3:0] a11, a12,
    input [3:0] a21, a22,
    output [3:0] l11, l12, l21, l22,
    output [3:0] u11, u12, u21, u22
);

// Intermediate signals for calculations
wire [3:0] l21_temp; // Temporary variable for L(2,1)
wire [3:0] u11_temp; // Temporary variable for U(1,1)

// Calculate L and U matrices
assign l11 = 4'b0001; // L(1,1) is always 1
assign l12 = 4'b0000; // L(1,2) is 0
assign l21_temp = a21 / a11; // L(2,1) = A(2,1) / A(1,1)
assign l21 = l21_temp; // L(2,1)
assign l22 = 4'b0001; // L(2,2) is always 1

assign u11 = a11; // U(1,1) = A(1,1)
assign u12 = a12; // U(1,2) = A(1,2)
assign u21 = 4'b0000; // U(2,1) is 0
assign u22 = a22 - (l21_temp * u12); // U(2,2) = A(2,2) - L(2,1) * U(1,2)

endmodule