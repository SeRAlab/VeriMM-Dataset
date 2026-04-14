module top_module(
    DIODE
);input DIODE;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Diode functionality
    assign VPWR = DIODE ? VPB : VGND;
    assign VNB = DIODE ? VGND : VPWR;

endmodule