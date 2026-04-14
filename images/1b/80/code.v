module fixed_point_adder (
    input [7:0] a,  // First fixed-point number
    input [7:0] b,  // Second fixed-point number
    output [7:0] sum // Sum of fixed-point numbers
);
    wire [8:0] full_sum; // 9 bits to capture overflow

    assign full_sum = a + b; // Perform addition

    // Check for overflow and saturate if necessary
    assign sum = (full_sum > 8'b01111111) ? 8'b01111111 : // Saturate to max if overflow
                 (full_sum < 8'b10000000) ? 8'b00000000 : // Saturate to min if below min
                 full_sum[7:0]; // Otherwise, take the lower 8 bits
endmodule