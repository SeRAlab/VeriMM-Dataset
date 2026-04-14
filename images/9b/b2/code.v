module top_module(
    input  A   ,
    input  B   ,
    input  C   ,
    output X   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);assign X = A | B | C;
endmodule