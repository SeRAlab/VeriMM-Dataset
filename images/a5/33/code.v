module top_module(
    X   ,
    A   ,
    B   ,
    C   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire or1_out;

    // Using a simple OR gate implementation since sky130_fd_sc_hvl__or3 is unknown
    assign or1_out = A | B | C;

    assign X = or1_out;

endmodule