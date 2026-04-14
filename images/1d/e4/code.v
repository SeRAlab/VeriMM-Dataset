module fixed_point_multiplier (
    input signed [7:0] a,
    input signed [7:0] b,
    output signed [15:0] product
);
    assign product = a * b;
endmodule