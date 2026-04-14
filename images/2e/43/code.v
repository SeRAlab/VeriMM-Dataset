module matrix_mult (
    input [3:0] A00, A01,
    input [3:0] A10, A11,
    input [3:0] B00, B01,
    input [3:0] B10, B11,
    output reg [7:0] C00, C01,
    output reg [7:0] C10, C11
);
    always @(*) begin
        C00 = A00 * B00 + A01 * B10; // C[0][0]
        C01 = A00 * B01 + A01 * B11; // C[0][1]
        C10 = A10 * B00 + A11 * B10; // C[1][0]
        C11 = A10 * B01 + A11 * B11; // C[1][1]
    end
endmodule