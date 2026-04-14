module top_module(
    X ,
    A1,
    A2,
    A3,
    B1,
    B2
);output X ;
    input  A1;
    input  A2;
    input  A3;
    input  B1;
    input  B2;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign X = (A1 | A2 | A3 | B1 | B2) ? ((A1 | A2 | A3 | B1 | B2) & !(A1 & A2 & A3 & B1 & B2)) : 0;

endmodule