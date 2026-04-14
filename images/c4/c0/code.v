module logic_gate (
    input  A1  ,
    input  A2  ,
    input  B1  ,
    input  C1  ,
    output X   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);

    assign X = (A1 & !A2) | (B1 & C1);

endmodule