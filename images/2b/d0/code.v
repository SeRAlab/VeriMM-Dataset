module hazard_detection (
    input wire A,
    input wire B,
    input wire C,
    output wire Y
);

assign Y = (A && B) || (B && ~C) || (A && ~C);

endmodule