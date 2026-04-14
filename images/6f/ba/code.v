module top_module(
    X      ,
    A      ,
    SLEEP_B,
    VPWR   ,
    VGND   ,
    VPB    ,
    VNB
);output X      ;
    input  A      ;
    input  SLEEP_B;
    input  VPWR   ;
    input  VGND   ;
    input  VPB    ;
    input  VNB    ;

    wire A_iso, SLEEP_B_iso, VPWR_iso, VGND_iso, VPB_iso, VNB_iso;

    assign A_iso = A ^ VPWR;
    assign SLEEP_B_iso = SLEEP_B ^ VGND;
    assign VPWR_iso = VPWR;
    assign VGND_iso = VGND;
    assign VPB_iso = VPB;
    assign VNB_iso = VNB;

    assign X = A_iso & SLEEP_B_iso & VPWR_iso & VGND_iso & VPB_iso & VNB_iso;

endmodule