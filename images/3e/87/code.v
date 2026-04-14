module fixed_point_multiplier (
    input [15:0] a,       // 16-bit fixed-point input
    input [15:0] b,       // 16-bit fixed-point input
    output [31:0] result  // 32-bit fixed-point output
);

    // Perform multiplication of two fixed-point numbers
    // Multiply the two inputs as integers
    wire [31:0] product = a * b;
  
    // Since we are multiplying two Q8.8 numbers, we must adjust the result
    // by shifting right by 8 bits (to account for the fixed-point format).
    assign result = product >> 8; // Shift right to get the Q16.16 format
endmodule