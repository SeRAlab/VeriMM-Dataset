module hazard_detection(
    input A,
    input B,
    input C,
    output H
);
    assign H = (A & B & ~C) | (A & ~B & C) | (~A & B & C);
endmodule