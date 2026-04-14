module fixed_point_adder (
    input [15:0] a, // First fixed-point number
    input [15:0] b, // Second fixed-point number
    output [15:0] sum // Sum of a and b
);
    wire signed [16:0] full_sum; // Use an extra bit for overflow handling
    assign full_sum = {1'b0, a} + {1'b0, b}; // Adding with sign extension

    assign sum = (full_sum > 16'h7FFF) ? 16'h7FFF : // Saturate to max
                 (full_sum < 16'h8000) ? 16'h8000 : // Saturate to min
                 full_sum[15:0]; // Normal output
endmodule