module top_module(
    input  A,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Output logic
    assign X = A;

endmodule