module LU_Decomposition(
    input [7:0] a11,
    input [7:0] a12,
    input [7:0] a21,
    input [7:0] a22,
    output reg [7:0] l11,
    output reg [7:0] l21,
    output reg [7:0] l12,
    output reg [7:0] u11,
    output reg [7:0] u12,
    output reg [7:0] u22
);

always @(*) begin
    // L matrix
    l11 = 8'h01; // L11 is always 1 for 2x2
    l21 = a21 / a11; // L21 = A21 / A11
    l12 = 8'h00; // L12 is 0 for 2x2
    
    // U matrix
    u11 = a11; // U11 = A11
    u12 = a12; // U12 = A12
    u22 = a22 - l21 * u12; // U22 = A22 - L21 * U12
end

endmodule