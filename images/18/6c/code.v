module matrix_factorization(
    input [3:0] a00, input [3:0] a01,
    input [3:0] a10, input [3:0] a11,
    input [3:0] b00, input [3:0] b01,
    input [3:0] b10, input [3:0] b11,
    output [3:0] c00, output [3:0] c01,
    output [3:0] c10, output [3:0] c11
);
    assign c00 = a00 * b00;
    assign c01 = a01 * b01;
    assign c10 = a10 * b10;
    assign c11 = a11 * b11;
endmodule