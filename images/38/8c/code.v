module floating_point_multiplier (
    input [31:0] a, // First floating-point input
    input [31:0] b, // Second floating-point input
    output [31:0] result // Result of multiplication
);
    wire [7:0] exponent_a;
    wire [7:0] exponent_b;
    wire [7:0] exponent_result;
    wire [23:0] mantissa_a;
    wire [23:0] mantissa_b;
    wire [23:0] mantissa_result;
    wire sign_a;
    wire sign_b;
    wire sign_result;

    assign sign_a = a[31];
    assign sign_b = b[31];
    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    assign mantissa_a = {1'b1, a[22:0]}; // Implicit leading 1 for normalized values
    assign mantissa_b = {1'b1, b[22:0]};

    assign sign_result = sign_a ^ sign_b; // XOR for sign calculation
    assign exponent_result = exponent_a + exponent_b - 8'd127; // Adjust for bias
    assign mantissa_result = mantissa_a * mantissa_b; // Mantissa multiplication

    assign result = {sign_result, exponent_result, mantissa_result[47:24]}; // Truncate mantissa

endmodule