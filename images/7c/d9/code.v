module top_module(
    UDP_OUT,
    UDP_IN ,
    VPWR
);output UDP_OUT;
    input  UDP_IN ;
    input  VPWR   ;

    assign UDP_OUT = UDP_IN & VPWR;

endmodule