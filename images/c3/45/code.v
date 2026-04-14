module bitwise_full_adder (
    input  A   ,
    input  B   ,
    input  CIN ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB ,
    output COUT,
    output SUM 
);

    assign SUM = (A ^ B) ^ CIN;
    assign COUT = (A & B) | (CIN & (A ^ B));

endmodule