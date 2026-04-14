module binary_incrementer(
    input [3:0] a,
    output [3:0] result
);
    assign result = a + 1;
endmodule