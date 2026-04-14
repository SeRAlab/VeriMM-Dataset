module top_module(
    input  A1,
    input  A2,
    input  A3,
    input  B1,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Logic to produce output signal X
    assign X = (A1 & ~A2) ? 1'b1 : (A2 & ~A1) ? 1'b0 : (A1 & A2 & A3) ? 1'b1 : (A1 == A2) ? B1 : 1'bx;

endmodule