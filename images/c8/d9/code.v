module mux2to1(
    input A,
    input B,
    input sel,
    output Z
);

    assign Z = sel ? B : A;

endmodule