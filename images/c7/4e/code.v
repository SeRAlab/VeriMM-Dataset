module conditional_output(
    input A,
    input B,
    input C,
    output X
);

    assign X = (A == 1) ? B : C;

endmodule