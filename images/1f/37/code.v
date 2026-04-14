module hazard_detection(
    input wire A,
    input wire B,
    input wire C,
    output wire hazard_detect
);
    assign hazard_detect = (A & B & ~C) | (A & ~B & C) | (~A & B & C);
endmodule