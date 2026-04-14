module nor_gate(
    input A,
    input B,
    output Z
);

    assign Z = ~(A | B);

endmodule