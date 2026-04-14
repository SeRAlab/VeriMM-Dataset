module matrix_mult(
    input [7:0] A00, A01, A10, A11,  // First matrix
    input [7:0] B00, B01, B10, B11,  // Second matrix
    output [15:0] R00, R01, R10, R11  // Result matrix
);

assign R00 = A00 * B00 + A01 * B10;  // Result[0][0]
assign R01 = A00 * B01 + A01 * B11;  // Result[0][1]
assign R10 = A10 * B00 + A11 * B10;  // Result[1][0]
assign R11 = A10 * B01 + A11 * B11;  // Result[1][1]

endmodule