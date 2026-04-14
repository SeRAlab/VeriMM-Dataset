module fixed_point_multiplier (
    input signed [15:0] a, // 16-bit signed fixed-point input
    input signed [15:0] b, // 16-bit signed fixed-point input
    output signed [31:0] result // 32-bit signed fixed-point output
);
    wire signed [31:0] a_extended; // Extended a to 32 bits
    wire signed [31:0] b_extended; // Extended b to 32 bits

    assign a_extended = {a, 16'b0}; // Left shift a by 16 to account for fixed-point
    assign b_extended = {b, 16'b0}; // Left shift b by 16 to account for fixed-point

    assign result = a_extended * b_extended; // Perform multiplication

endmodule