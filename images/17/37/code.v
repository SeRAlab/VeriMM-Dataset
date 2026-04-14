module float_mul (
    input [31:0] a,
    input [31:0] b,
    output [31:0] product
);
    wire [7:0] exp_a, exp_b, exp_product;
    wire [23:0] frac_a, frac_b, frac_product;
    wire sign_a, sign_b, sign_product;

    assign sign_a = a[31];
    assign sign_b = b[31];
    assign exp_a = a[30:23];
    assign exp_b = b[30:23];
    assign frac_a = {1'b1, a[22:0]}; // implicit leading 1
    assign frac_b = {1'b1, b[22:0]}; // implicit leading 1

    assign sign_product = sign_a ^ sign_b; // XOR for sign
    assign exp_product = exp_a + exp_b - 8'd127; // subtract the bias
    assign frac_product = frac_a * frac_b; // multiply the fractions

    assign product = {sign_product, exp_product, frac_product[46:24]}; // take the most significant bits

endmodule