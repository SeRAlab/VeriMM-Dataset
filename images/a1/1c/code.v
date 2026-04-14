module top_module(
    A,
    B,
    X,
    SLEEP_B
);input A;
    input B;
    output X;
    input SLEEP_B;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = ~(A & B) & SLEEP_B;

endmodule