module four_bit_adder (
    input [3:0] A,        // First 4-bit input
    input [3:0] B,        // Second 4-bit input
    input carry_in,       // Carry input
    output [3:0] sum,     // 4-bit sum output
    output carry_out       // Carry output
);
    wire [4:0] temp_sum;  // Temporary 5-bit sum to hold carry

    // Perform addition
    assign temp_sum = A + B + carry_in; // 4-bit + 4-bit + 1-bit
    assign sum = temp_sum[3:0];          // Take the lower 4 bits as sum
    assign carry_out = temp_sum[4];      // Take the 5th bit as carry out
endmodule