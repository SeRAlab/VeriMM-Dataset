module logic_gate (
    X,
    A1,
    A2,
    B1,
    B2,
    C1
);

    output X;
    input A1;
    input A2;
    input B1;
    input B2;
    input C1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire AB_high = (A1 & A2) & (!B1 & !B2);

    assign X = (AB_high | C1) ? 1'b1 : 1'b0;

endmodule