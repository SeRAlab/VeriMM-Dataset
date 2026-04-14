module nand_gate (
    Z,
    A,
    B
);

    output Z;
    input A;
    input B;

    assign Z = ~(A & B);

endmodule