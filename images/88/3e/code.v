module top_module(
    input [31:0] a,
    input [31:0] b,
    output [31:0] sum,
    output overflow
);// Extracting sign, exponent and mantissa of a and b
    wire sign_a = a[31];
    wire sign_b = b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [22:0] mant_a = a[22:0];
    wire [22:0] mant_b = b[22:0];

    // Finding the larger exponent and shifting the mantissa of the smaller exponent
    wire [7:0] larger_exp;
    wire [22:0] larger_mant;
    wire [22:0] smaller_mant;
    wire [23:0] shifted_mant;
    wire [23:0] sum_mant;
    wire sum_exp;
    wire sum_sign;

    // Finding the larger exponent
    assign larger_exp = (exp_a > exp_b) ? exp_a : exp_b;

    // Shifting the mantissa of the smaller exponent
    assign smaller_mant = (exp_a > exp_b) ? mant_b : mant_a;
    assign shifted_mant = (exp_a > exp_b) ? {1'b0, smaller_mant} >> (exp_a - exp_b) : {1'b0, smaller_mant} >> (exp_b - exp_a);

    // Adding the mantissas
    assign sum_mant = (sign_a ^ sign_b) ? mant_a - shifted_mant : mant_a + shifted_mant;

    // Checking for overflow and underflow
    assign overflow = (sum_mant[23] == 1) ? 1'b1 : 1'b0;
    assign sum_exp = (overflow == 1'b1) ? larger_exp + 1 : larger_exp;
    assign sum_sign = (sum_mant[23] == 1) ? ~(sign_a ^ sign_b) : (sign_a ^ sign_b);

    // Normalizing the mantissa
    assign larger_mant = (sum_mant[23] == 1) ? sum_mant[22:0] >> 1 : sum_mant[22:0];
    assign sum = {sum_sign, sum_exp, larger_mant};

endmodule