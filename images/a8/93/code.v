module top_module(
    //# {{data|Data Signals}}
    input  UDP_IN ,
    output UDP_OUT,

    //# {{power|Power}}
    input  VPWR   ,
    input  VGND
);assign UDP_OUT = UDP_IN & ~VPWR;

endmodule