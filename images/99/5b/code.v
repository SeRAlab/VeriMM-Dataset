module top_module(
    X   ,
    A1  ,
    A2  ,
    B1  ,
    C1  ,
    D1  ,
    VPWR,
    VGND
);output X   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  C1  ;
    input  D1  ;
    input  VPWR;
    input  VGND;
    
    assign X = A1 & (A2 | B1) & (C1 ^ D1);
    
    // Connect VPWR to power supply and VGND to ground
    assign VPWR = 1'b1;
    assign VGND = 1'b0;
    
endmodule