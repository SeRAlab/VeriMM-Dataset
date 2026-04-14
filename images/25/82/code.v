module hazard_detection_and_resolution (
    input wire A,
    input wire B,
    output wire Y
);
    wire A_bar, B_bar;
    wire Y1, Y2, Y3;

    // Intermediate AND gates
    assign Y1 = A & B;            // Normal AND output
    assign Y2 = A & B_bar;        // A and not B
    assign Y3 = A_bar & B;        // Not A and B

    // Hazard detection and resolution logic
    assign Y = (Y1 | Y2 | Y3);     // Combine outputs to resolve hazards

endmodule