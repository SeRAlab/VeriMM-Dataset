module top_module(
    //# {{data|Data Signals}}
    input  A    ,
    output X    ,

    //# {{power|Power}}
    input  KAPWR,
    input  VPB  ,
    input  VPWR ,
    input  VGND ,
    input  VNB
);wire A_int;
assign A_int = A;

wire X_int;
assign X_int = A_int;

assign X = X_int;

endmodule