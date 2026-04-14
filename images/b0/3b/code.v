module binary_and(
    input [7:0] a,
    input [7:0] b,
    output [7:0] result
);
    assign result = a & b;
endmodule