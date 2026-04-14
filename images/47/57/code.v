module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);wire n1, n2, n3;

    // Basic NOR gate implementation
    assign n1 = ~(A | B);
    assign n2 = ~(C | D);
    assign n3 = ~(n1 | n2);

    assign Y = n3;

endmodule