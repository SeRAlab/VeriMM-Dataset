module hazard_detection (
    input A,
    input B,
    input C,
    output Y
);
    wire ab, ac, bc, not_ab, not_ac, not_bc;

    assign ab = A & B;
    assign ac = A & C;
    assign bc = B & C;

    assign not_ab = ~ab;
    assign not_ac = ~ac;
    assign not_bc = ~bc;

    assign Y = (ab & not_ac & not_bc) | (not_ab & ac & not_bc) | (not_ab & not_ac & bc);
endmodule