module sky130_fd_sc_hs__a22oi (
    Y ,
    A1,
    A2,
    B1,
    B2
);

    output Y ;
    input  A1;
    input  A2;
    input  B1;
    input  B2;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    // assign Y to the AND of A1, A2, B1, and B2
    assign Y = A1 & A2 & B1 & B2;

endmodule