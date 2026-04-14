module mux2to1 (
    input A,
    input B,
    input S,
    output X
);

    assign X = S ? B : A;

endmodule