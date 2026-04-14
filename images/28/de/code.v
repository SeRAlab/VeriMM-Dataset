module matrix_multiply (
    input [3:0] a00, a01, // First matrix: a00 a01
    input [3:0] a10, a11, // Second matrix: a10 a11
    input [3:0] b00, b01, // First matrix: b00 b01
    input [3:0] b10, b11, // Second matrix: b10 b11
    output [7:0] c00, c01, // Result matrix: c00 c01
    output [7:0] c10, c11  // Result matrix: c10 c11
);
    assign c00 = a00 * b00 + a01 * b10; // c00 = a00*b00 + a01*b10
    assign c01 = a00 * b01 + a01 * b11; // c01 = a00*b01 + a01*b11
    assign c10 = a10 * b00 + a11 * b10; // c10 = a10*b00 + a11*b10
    assign c11 = a10 * b01 + a11 * b11; // c11 = a10*b01 + a11*b11
endmodule