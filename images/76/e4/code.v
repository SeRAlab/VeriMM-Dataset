module top_module(
    Y ,
    A1,
    A2,
    A3,
    B1
);output Y ;
    input  A1;
    input  A2;
    input  A3;
    input  B1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign Y = A1 & A2 & A3 & B1;

endmodule