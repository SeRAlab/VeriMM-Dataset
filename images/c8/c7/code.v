module majority_3 (
    input A,
    input B,
    input C,
    output X
);

    wire AB, AC, BC;

    assign AB = A & B;
    assign AC = A & C;
    assign BC = B & C;

    assign X = (AB | AC | BC);

endmodule