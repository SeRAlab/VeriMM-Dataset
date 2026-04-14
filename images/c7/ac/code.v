module three_to_one (
    input  A,
    input  B,
    input  C,
    output X
);

    wire AB = A & B;
    wire AC = A & C;
    wire BC = B & C;

    assign X = AB | AC | BC;

endmodule