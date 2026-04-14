module top_module(
    Y   ,
    A1  ,
    A2  ,
    A3  ,
    A4  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  A4  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    wire Y_internal; // Internal wire for output connection

    assign Y_internal = (A1 ^ A2 ^ A3 ^ A4 ^ B1);

    // Assuming that sky130_fd_sc_ms__a41oi is a defined module in your library.
    // It seems there was a missing definition for the module. A typo or oversight might have occurred.
    // Verify that the module exists in your design files or library.
    // If it doesn't exist, you may want to replace it or create it accordingly.

    // If you expect to logically connect/implement the function without a pre-defined module
    // for 'sky130_fd_sc_ms__a41oi', you can simply use the assigned value directly:
    assign Y = Y_internal;

    // Uncomment below if 'sky130_fd_sc_ms__a41oi' needs to be instantiated
    // sky130_fd_sc_ms__a41oi base (
    //     .Y(Y_internal),
    //     .A1(A1),
    //     .A2(A2),
    //     .A3(A3),
    //     .A4(A4),
    //     .B1(B1),
    //     .VPWR(VPWR),
    //     .VGND(VGND),
    //     .VPB(VPB),
    //     .VNB(VNB)
    // );

    assign Y = Y_internal; // Assign the computed value to output Y

endmodule