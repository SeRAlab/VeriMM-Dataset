module top_module(
    input  A1  ,
    input  A2  ,
    input  B1  ,
    input  C1  ,
    output Y   ,

    input  VPWR,
    input  VGND
);assign Y = A1 & A2 & B1 & C1;

endmodule