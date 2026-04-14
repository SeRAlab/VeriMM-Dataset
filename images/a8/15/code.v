module top_module(
    output Y,
    input A1,
    input A2,
    input A3,
    input B1
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Internal signal for the selection logic
    wire sel;
    wire A_is_high;

    // Implementing a simple 4-to-1 mux logic
    assign sel = B1;
    assign A_is_high = (A1 & ~sel) | (A2 & sel) | (A3 & ~sel);

    assign Y = A_is_high;

endmodule