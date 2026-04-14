module multiplier_64x64 (
    input [63:0] a,
    input [63:0] b,
    output [127:0] product
);
    assign product = a * b;
endmodule