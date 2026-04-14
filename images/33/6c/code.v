module hazard_detection (
    input A,
    input B,
    input C,
    output F
);
    wire w1, w2, w3;
    assign w1 = A & B;
    assign w2 = B & C;
    assign w3 = A & C;
    assign F = w1 | w2 | w3; // F = A.B + B.C + A.C
endmodule