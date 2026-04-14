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

    wire A_and = A1 & A2 & A3;
    wire A_or = A1 | A2 | A3;

    assign Y = (B1 == 1'b1) ? 1'b1 : ((A_and == 1'b1) || ((A_or - A_and) >= 2'b10));

endmodule