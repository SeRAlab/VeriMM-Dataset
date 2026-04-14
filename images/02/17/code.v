module matrix_mult (
    input [3:0] A11, A12, A21, A22,
    input [3:0] B11, B12, B21, B22,
    output reg [3:0] C11, C12, C21, C22
);
    always @(*) begin
        C11 = A11 * B11 + A12 * B21;
        C12 = A11 * B12 + A12 * B22;
        C21 = A21 * B11 + A22 * B21;
        C22 = A21 * B12 + A22 * B22;
    end
endmodule