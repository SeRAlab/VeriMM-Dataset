module my_or(
    input A,
    input B,
    input C,
    input D_N,
    output X
);

    wire not_D_N;
    assign not_D_N = ~D_N;

    assign X = (A | B | C) & not_D_N;

endmodule