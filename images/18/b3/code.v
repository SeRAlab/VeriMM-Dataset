module hazard_detection(
    input A,
    input B,
    input C,
    output hazard
);
    // Logic for hazard detection
    assign hazard = (A & B & ~C) | (A & ~B & C) | (~A & B & C);
endmodule