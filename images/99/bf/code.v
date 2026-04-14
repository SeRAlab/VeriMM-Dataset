module top_module(
    VPWR,
    VGND,
    VPB ,
    VNB,
    PWR,
    GND
);// Module ports
    input VPWR;
    input VGND;
    input VPB ;
    input VNB ;
    output PWR;
    output GND;

    // No contents.
    assign PWR = VPWR | VPB;
    assign GND = VGND | VNB;

endmodule