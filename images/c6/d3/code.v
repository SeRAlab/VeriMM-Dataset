module majority (
    input  A,
    input  B,
    input  C,
    output X
);
    wire AB = A & B;
    wire AC = A & C;
    wire BC = B & C;
    wire ABC = AB | AC | BC;
    assign X = ABC;
endmodule