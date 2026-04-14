module top_module(
    Y,
    A1,
    A2,
    A3,
    B1
);output Y;
    input  A1;
    input  A2;
    input  A3;
    input  B1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire temp1, temp2;

    // Logic for Y output based on A and B inputs
    assign temp1 = (A1 & A2 & A3 & ~B1);
    assign temp2 = (~A1 & ~A2 & ~A3 & B1);

    // Assigning Y based on the intermediate signals
    assign Y = temp1 | temp2;

endmodule