module fixed_point_adder (
    input [7:0] a, // 8-bit fixed-point input a
    input [7:0] b, // 8-bit fixed-point input b
    output [7:0] sum // 8-bit fixed-point output sum
);
    wire [8:0] temp_sum; // 9-bit temp_sum to handle overflow

    assign temp_sum = a + b; // Add inputs
    assign sum = temp_sum[7:0]; // Assign lower 8 bits (overflow is discarded)

endmodule