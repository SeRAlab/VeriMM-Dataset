module top_module(
    Z,
    A,
    B
);output Z;
    input A;
    input B;

    assign Z = ~(A & B);

endmodule