module fixed_point_multiplier (
    input signed [15:0] A,
    input signed [15:0] B,
    output signed [31:0] P
);
    assign P = A * B; // Multiply and produce the fixed-point product
endmodule