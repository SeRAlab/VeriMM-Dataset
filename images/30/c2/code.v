module float_mult (
    input  [31:0] a, // First floating-point number
    input  [31:0] b, // Second floating-point number
    output [31:0] result // Result of multiplication
);

    wire [7:0] exponent_a = a[30:23];
    wire [7:0] exponent_b = b[30:23];
    wire [23:0] significand_a = {1'b1, a[22:0]}; // Adding implicit leading 1
    wire [23:0] significand_b = {1'b1, b[22:0]}; // Adding implicit leading 1
    
    wire [7:0] exponent_result = exponent_a + exponent_b - 8'd127; // Bias adjustment
    wire [47:0] significand_result = significand_a * significand_b; // Multiplication of significands

    // Normalization of the result
    wire [23:0] normalized_significand;
    wire [7:0] final_exponent;
    wire overflow, underflow;

    assign overflow = significand_result[47]; // Check for overflow
    assign normalized_significand = overflow ? significand_result[46:23] : significand_result[47:24];
    assign final_exponent = overflow ? exponent_result + 1 : exponent_result;

    // Final result assembly 
    assign result = {a[31] ^ b[31], final_exponent, normalized_significand[22:0]}; // Sign, exponent, significand

endmodule