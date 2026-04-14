module top_module(
    input [1:0] a,
    input [1:0] b,
    output eq
);

    assign eq = (a == b);  // Comparator for equality

endmodule