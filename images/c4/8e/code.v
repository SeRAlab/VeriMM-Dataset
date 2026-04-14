module my_module (
    input  A1  ,
    input  A2  ,
    input  B1  ,
    output Y   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);

    assign Y = (A1 && !A2) || (!A1 && A2) || B1;

endmodule