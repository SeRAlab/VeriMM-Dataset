module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);wire n1, n2, n3;

    // Using built-in primitives for NOR gates instead of missing module
    assign n1 = ~(A | B);
    assign n2 = ~(C | D);
    assign n3 = ~(n1 | n2);

    assign Y = n3;

endmodule