module top_module(
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    // Dummy implementation of sky130_fd_sc_lp__a21oi module
    // Replace with the actual module definition or include its file.
    wire dummy_Y;
    assign dummy_Y = (A1 & A2) | (~B1);

    assign Y = dummy_Y;

    // Note: The following would typically be part of the sky130_fd_sc_lp__a21oi module
    // which is currently not provided. Assuming its ports as per the provided instance.
    // You would replace this part with the actual module definition
    // or ensure that the module `sky130_fd_sc_lp__a21oi` is instantiated correctly.

endmodule