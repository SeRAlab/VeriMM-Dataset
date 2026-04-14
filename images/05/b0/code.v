module fixed_point_multiplier (
    input signed [15:0] a,
    input signed [15:0] b,
    output signed [31:0] result
);
    // Define the scale factor
    localparam SCALE_FACTOR = 256; // 2^8
    wire signed [31:0] product;

    // Perform multiplication
    assign product = a * b;

    // Scale the result
    assign result = product / SCALE_FACTOR;
endmodule