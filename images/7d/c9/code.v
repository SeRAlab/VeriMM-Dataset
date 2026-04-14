module top_module(
    Y  ,
    A  ,
    B  ,
    C_N,
    D_N,
    VPWR
);// Module ports
    output Y  ;
    input  A  ;
    input  B  ;
    input  C_N;
    input  D_N;
    input  VPWR;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire nor_out  ;
    wire and_out_Y;

    //  Name  Output      Other arguments
    nor nor_gate (nor_out  , A, B              );
    and and_gate (and_out_Y, nor_out, C_N, D_N);
    buf buf_gate (Y       , and_out_Y, VPB, VNB);

endmodule