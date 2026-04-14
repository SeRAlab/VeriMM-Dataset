module top_module(
    input  A0,
    input  A1,
    input  A2,
    input  A3,
    input  S0,
    input  S1,
    output Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire w0, w1, w2;

    assign w0 = S1 & S0;
    assign w1 = S1 & ~S0;
    assign w2 = ~S1 & S0;

    assign Y = A0 & ~w0 & ~w2 | A1 & ~w1 & ~w2 | A2 & w0 & ~w1 | A3 & w1 & w2;

endmodule