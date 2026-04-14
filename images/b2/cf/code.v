module top_module(
    Y,
    A1,
    A2,
    A3,
    B1
);output Y;
    input A1;
    input A2;
    input A3;
    input B1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire temp1;
    wire temp2;

    // Implementing a basic gate simulation for o31ai
    wire N1, N2, N3;
    assign N1 = A1 & A2;
    assign N2 = N1 & A3;
    assign N3 = N1 | B1;
    assign temp1 = ~(N2 | N3);

    assign temp2 = (A1 & !A2 & !A3 & !B1) | (A1 & !A2 & !A3 & B1) | (!A1 & A2);

    assign Y = temp1 & temp2;

endmodule