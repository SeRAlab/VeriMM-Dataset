module hazard_detection (
    input wire A,
    input wire B,
    input wire C,
    output wire Hazard
);
    assign Hazard = (A & B) | (B & C) | (A & C);
endmodule