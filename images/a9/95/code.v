module top_module(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] product
);reg [22:0] a_mantissa, b_mantissa, product_mantissa;
    reg [7:0] a_exponent, b_exponent;
    reg a_sign, b_sign, product_sign;
    reg [31:0] a_shifted, b_shifted;
    reg [63:0] product_intermediate;
    reg [7:0] product_exponent;

    always @(*) begin
        a_sign = a[31];
        b_sign = b[31];
        a_exponent = a[30:23];
        b_exponent = b[30:23];
        a_mantissa = a[22:0];
        b_mantissa = b[22:0];

        a_shifted = {1'b1, a_mantissa} << 1;
        b_shifted = {1'b1, b_mantissa} << 1;

        product_intermediate = a_shifted * b_shifted;
        product_mantissa = product_intermediate[53:31]; // Use the correct bit slicing

        // Calculate product sign, exponent, and mantissa
        product_sign = a_sign ^ b_sign;
        product_exponent = a_exponent + b_exponent - 8'd127; // Specify the width of 127 explicitly
        product = {product_sign, product_exponent, product_mantissa}; // Output assignment

    end

endmodule