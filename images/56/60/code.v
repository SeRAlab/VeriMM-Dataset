module top_module(
    X ,
    A1,
    A2,
    B1,
    C1
);output X ;
    input  A1;
    input  A2;
    input  B1;
    input  C1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign X = ((A1 & A2 & ~B1 & ~C1) | (A1 | A2 | (B1 & C1)) | (~A1 & A2 & B1 & C1)) ? 1'b1 : 1'b0;

endmodule