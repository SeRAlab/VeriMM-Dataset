module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    output Y,
    input VPWR,
    input VGND
);wire Y1, Y2, Y3;

    // First two-input AND gates combined to create a four-input AND
    assign Y1 = A1 & A2;  // Create first intermediate output
    assign Y2 = Y1 & A3;  // Create second intermediate output
    assign Y3 = Y2 & B1;  // Final output

    assign Y = Y3;

endmodule