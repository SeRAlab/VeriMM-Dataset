module signed_multiplier (
    input signed [63:0] a,
    input signed [63:0] b,
    output signed [127:0] product
);
    assign product = a * b;
endmodule