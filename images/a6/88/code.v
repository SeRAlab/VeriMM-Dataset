module top_module(
    output X      ,
    input  A      ,
    input  SLEEP_B,
    input  VPWR   ,
    input  VGND   ,
    input  VPB    ,
    input  VNB
);assign X = A & ~SLEEP_B;

endmodule