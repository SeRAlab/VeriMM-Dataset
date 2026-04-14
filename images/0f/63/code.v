module LU_Decomposition (
    input [7:0] A11, A12, 
    input [7:0] A21, A22,
    output reg [7:0] L11, L12, 
    output reg [7:0] L21, L22,
    output reg [7:0] U11, U12, 
    output reg [7:0] U21, U22
);

always @(*) begin
    // L matrix
    L11 = 8'd1; // L11 is always 1
    L12 = 8'd0; // L12 is 0
    L21 = A21 / A11; // L21 is A21 divided by A11
    L22 = 8'd1; // L22 is always 1

    // U matrix
    U11 = A11; // U11 is A11
    U12 = A12; // U12 is A12
    U21 = 8'd0; // U21 is 0
    U22 = A22 - (L21 * U12); // U22 is A22 - L21 * U12
end

endmodule