module float_mult (
    input [31:0] A, // First floating-point number
    input [31:0] B, // Second floating-point number
    output [31:0] P // Product of A and B
);
    wire [7:0] expA, expB, expP;
    wire [23:0] mantA, mantB, mantP;
    wire signA, signB, signP;

    // Extracting sign, exponent, and mantissa
    assign signA = A[31];
    assign signB = B[31];
    assign expA = A[30:23] - 8'b01111111; // Unbias exponent
    assign expB = B[30:23] - 8'b01111111; // Unbias exponent
    assign mantA = {1'b1, A[22:0]}; // Normalized mantissa
    assign mantB = {1'b1, B[22:0]}; // Normalized mantissa

    // Multiplying mantissas
    assign mantP = mantA * mantB;
    assign expP = expA + expB + (mantP[47] ? 1 : 0); // Adjust for overflow
    assign signP = signA ^ signB; // Sign of the product

    // Constructing the output
    assign P = {signP, expP + 8'b01111111, mantP[46:24]}; // Bias the exponent back

endmodule