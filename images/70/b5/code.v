module top_module(
    input [3:0] A,
    output [3:0] S
);parameter [3:0] B = 4'hA; // Constant

    assign S = A + B; // Adder

endmodule