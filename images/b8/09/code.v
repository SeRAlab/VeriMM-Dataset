module top_module(
    //# {{data|Data Signals}}
    input  A1  ,
    input  A2  ,
    input  A3  ,
    input  B1  ,
    output Y   ,

    //# {{power|Power}}
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);// Declare internal wires
wire Y1, Y2, Y3;

// Implement logic
assign Y1 = A1;
assign Y2 = (A2 & !A3);
assign Y3 = (A3 & !A2);

assign Y = (B1 == 0) ? Y1 : ((Y2 | Y3) ? 1 : 0);

endmodule