module hazard_detection (
    input wire A,
    input wire B,
    output wire Y
);
    assign Y = A & B; // Hazard condition
endmodule