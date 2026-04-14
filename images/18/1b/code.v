module fixed_point_adder (
    input [15:0] a,
    input [15:0] b,
    output [15:0] sum
);
    wire signed [16:0] extended_a;
    wire signed [16:0] extended_b;
    wire signed [16:0] extended_sum;

    assign extended_a = {a[15], a}; // Sign extend a
    assign extended_b = {b[15], b}; // Sign extend b
    assign extended_sum = extended_a + extended_b;

    // Wrap around for overflow
    assign sum = extended_sum[15:0]; // Take the lower 16 bits
endmodule