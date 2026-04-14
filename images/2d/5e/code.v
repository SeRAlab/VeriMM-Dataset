module matrix_mult (
    input [3:0] A0, A1, A2, A3, // Elements of matrix A
    input [3:0] B0, B1, B2, B3, // Elements of matrix B
    output reg [3:0] C0, C1, C2, C3 // Elements of resultant matrix C
);
    always @* begin
        C0 = A0 * B0 + A1 * B2; // C[0][0]
        C1 = A0 * B1 + A1 * B3; // C[0][1]
        C2 = A2 * B0 + A3 * B2; // C[1][0]
        C3 = A2 * B1 + A3 * B3; // C[1][1]
    end
endmodule