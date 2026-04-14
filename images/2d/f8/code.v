module float_mult (
    input [31:0] a, // First floating-point number
    input [31:0] b, // Second floating-point number
    output [31:0] product // Result of multiplication
);
    // Internal signals
    wire [23:0] mant_a, mant_b;
    wire [7:0] exp_a, exp_b;
    wire sign_a, sign_b;
    
    // Extracting sign, exponent and mantissa from the inputs
    assign sign_a = a[31];
    assign sign_b = b[31];
    assign exp_a = a[30:23] - 127; // Bias of 127
    assign exp_b = b[30:23] - 127;
    assign mant_a = {1'b1, a[22:0]}; // Implicit leading 1
    assign mant_b = {1'b1, b[22:0]}; // Implicit leading 1
    
    // Multiplying mantissas and adding exponents
    wire [47:0] mant_product = mant_a * mant_b; // 24 x 24 = 48
    wire [8:0] exp_product = exp_a + exp_b + 127; // bias back
    
    // Normalization and rounding would be implemented here
    // For simplicity, assume no need for normalization/rounding in this example
    assign product = {sign_a ^ sign_b, exp_product[7:0], mant_product[46:24]}; // Truncate to 23 bits

endmodule