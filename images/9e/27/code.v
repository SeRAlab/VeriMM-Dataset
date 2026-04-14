module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    output signed [7:0] result
);wire [7:0] unsigned_result;
    wire [7:0] signed_result;

    assign unsigned_result = A * B;

    // Check if the result is negative
    assign signed_result = (A[3] ^ B[3]) ? (~unsigned_result + 1) : unsigned_result;

    // Truncate the most significant bits if the result is greater than 8 bits
    assign result = signed_result[7:0];

endmodule