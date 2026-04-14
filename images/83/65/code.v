module top_module(
    Y,
    D0,
    D1,
    D2,
    D3,
    S0,
    S1
);output Y;
    input D0, D1, D2, D3;
    input S0, S1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire sel0, sel1;

    assign sel0 = ~S0;
    assign sel1 = ~S1;

    assign Y = (sel1 & sel0 & D0) | (sel1 & S0 & D1) | (S1 & sel0 & D2) | (S1 & S0 & D3);

endmodule