module float_multiplier(
    input [31:0] a,
    input [31:0] b,
    output [31:0] product
);
    wire [7:0] exponent_a, exponent_b, exponent_product;
    wire [23:0] mantissa_a, mantissa_b, mantissa_product;
    wire sign_a, sign_b, sign_product;
    
    assign sign_a = a[31];
    assign sign_b = b[31];
    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    assign mantissa_a = {1'b1, a[22:0]};
    assign mantissa_b = {1'b1, b[22:0]};
    
    assign sign_product = sign_a ^ sign_b;
    assign exponent_product = exponent_a + exponent_b - 8'd127;
    assign mantissa_product = mantissa_a * mantissa_b >> 23; // Shift to normalize
    
    assign product = {sign_product, exponent_product, mantissa_product[22:0]};
endmodule