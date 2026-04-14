module floating_point_multiplier (
    input [31:0] a,
    input [31:0] b,
    output [31:0] result
);
    wire sign_a = a[31];
    wire sign_b = b[31];
    wire sign_result = sign_a ^ sign_b; // XOR for sign

    wire [7:0] exponent_a = a[30:23];
    wire [7:0] exponent_b = b[30:23];
    wire [7:0] exponent_result = exponent_a + exponent_b - 8'd127; // bias adjustment

    wire [23:0] mantissa_a = {1'b1, a[22:0]}; // implicit leading 1
    wire [23:0] mantissa_b = {1'b1, b[22:0]}; // implicit leading 1
    wire [47:0] mantissa_result = mantissa_a * mantissa_b; // multiply mantissas

    // Normalize the result
    wire [23:0] normalized_mantissa;
    wire [7:0] normalized_exponent;
    wire shift;

    assign shift = mantissa_result[47]; // Check if need to shift
    assign normalized_mantissa = shift ? mantissa_result[46:23] : mantissa_result[47:24];
    assign normalized_exponent = shift ? exponent_result + 1 : exponent_result;

    assign result = {sign_result, normalized_exponent, normalized_mantissa[22:0]};
endmodule