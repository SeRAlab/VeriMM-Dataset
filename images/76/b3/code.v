module top_module(
    output X,
    input  A,
    input  B,
    input  C
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Instantiate the xnor gate
    xnor (X, A, B, C); // Using a behavioral XNOR for demonstration

endmodule