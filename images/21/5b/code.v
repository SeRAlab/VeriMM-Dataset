module hazard_detector (
    input wire A,
    input wire B,
    input wire C,
    output wire Y
);
    
    wire Y1, Y2, Y3;

    // Original logic without hazard detection
    assign Y1 = A & B;
    assign Y2 = B & C;
    assign Y3 = A & C;

    // Hazard detection logic
    assign Y = Y1 | Y2 | Y3;

endmodule