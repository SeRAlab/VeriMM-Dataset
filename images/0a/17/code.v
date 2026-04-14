module multiplier_32_to_64 (
    input [31:0] a,
    input [31:0] b,
    output [63:0] product
);
    assign product = a * b;
endmodule