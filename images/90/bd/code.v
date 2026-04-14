module top_module(
    COUT,
    SUM,
    A,
    B,
    CI
);output COUT;
    output SUM;
    input  A;
    input  B;
    input  CI;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Use a behavioral description for the full adder
    assign SUM = A ^ B ^ CI; // Sum calculation
    assign COUT = (A & B) | (B & CI) | (A & CI); // Carry-out calculation

endmodule