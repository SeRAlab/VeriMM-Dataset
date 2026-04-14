module Float_Multiplier (
    input [7:0] a, // 1 sign bit, 3 exponent bits, 4 fraction bits
    input [7:0] b, // 1 sign bit, 3 exponent bits, 4 fraction bits
    output reg [7:0] product // 1 sign bit, 3 exponent bits, 4 fraction bits
);
    wire sign_a = a[7];
    wire sign_b = b[7];
    wire [2:0] exp_a = a[6:4];
    wire [2:0] exp_b = b[6:4];
    wire [3:0] frac_a = a[3:0];
    wire [3:0] frac_b = b[3:0];

    wire sign_product = sign_a ^ sign_b;
    wire [2:0] exp_product = exp_a + exp_b - 3'b011; // adjusting bias
    wire [7:0] frac_product = frac_a * frac_b; // simple multiplication for fractions

    always @(*) begin
        product[7] = sign_product;
        product[6:4] = exp_product;
        product[3:0] = frac_product[3:0]; // taking lower 4 bits of product
    end
endmodule