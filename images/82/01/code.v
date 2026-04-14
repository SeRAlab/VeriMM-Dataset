module top_module(
    DIODE,
    VPWR ,
    VGND ,
    VPB  ,
    VNB,
    VOUT
);input DIODE;
    input signed [4:0] VPWR ;
    input signed [4:0] VGND ;
    input signed [4:0] VPB  ;
    input signed [4:0] VNB  ;
    output signed [4:0] VOUT;

    assign VOUT = (DIODE == 1) ? (VPB - VNB) : 0;

endmodule