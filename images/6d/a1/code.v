module top_module(
    Y   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    VPWR,
    VGND
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  VPWR;
    input  VGND;

    wire A1_high;
    wire A2_high;
    wire A3_high;
    wire B1_high;

    assign A1_high = (A1 == 1'b1);
    assign A2_high = (A2 == 1'b1);
    assign A3_high = (A3 == 1'b1);
    assign B1_high = (B1 == 1'b1);

    assign Y = (A1_high | (!A1_high & A2_high) | (!A1_high & !A2_high & A3_high) | (!A1_high & !A2_high & !A3_high & B1_high)) ? 1'b1 : 1'b0;

endmodule