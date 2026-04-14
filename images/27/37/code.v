module LU_Decomposition (
    input [7:0] a, // Matrix element a
    input [7:0] b, // Matrix element b
    input [7:0] c, // Matrix element c
    input [7:0] d, // Matrix element d
    output reg [7:0] l11, // L matrix element l11
    output reg [7:0] l21, // L matrix element l21
    output reg [7:0] u11, // U matrix element u11
    output reg [7:0] u12, // U matrix element u12
    output reg [7:0] u22  // U matrix element u22
);
    always @(*) begin
        // LU Decomposition for 2x2 Matrix
        l11 = a; // L11 = A11
        l21 = c / l11; // L21 = A21 / L11
        u11 = l11; // U11 = L11
        u12 = b; // U12 = A12
        u22 = d - l21 * u12; // U22 = A22 - L21 * U12
    end
endmodule