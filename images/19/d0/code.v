module floating_point_multiplier(
    input [31:0] a, // First floating-point number
    input [31:0] b, // Second floating-point number
    output [31:0] product // Resulting floating-point number
);
    wire [7:0] exponent_a;
    wire [7:0] exponent_b;
    wire [7:0] exponent_product;
    wire [23:0] mantissa_a;
    wire [23:0] mantissa_b;
    wire [47:0] mantissa_product;

    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    assign mantissa_a = {1'b1, a[22:0]}; // Normalize
    assign mantissa_b = {1'b1, b[22:0]}; // Normalize

    assign mantissa_product = mantissa_a * mantissa_b;
    assign exponent_product = exponent_a + exponent_b - 127; // Bias adjustment

    assign product = {exponent_product, mantissa_product[46:24]}; // Truncate to 23 bits

endmodule