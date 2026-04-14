module multi_64bit (
    input [63:0] a,
    input [63:0] b,
    output [127:0] product
);
    assign product = a * b;
endmodule