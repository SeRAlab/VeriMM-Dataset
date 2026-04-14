module top_module(
    X   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    C1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  C1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire and_wire;
    wire or_wire;
    wire xor_wire;
    wire power_wire;

    assign and_wire = A1 & A2 & A3;
    assign or_wire = B1 | C1;
    assign xor_wire = VPB ^ VNB;
    assign power_wire = VPWR & VGND;

    assign X = and_wire | or_wire | xor_wire | power_wire;

endmodule