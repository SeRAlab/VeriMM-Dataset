module top_module(
    Z   ,
    A   ,
    B   ,
    C
);output Z;
    input  A;
    input  B;
    input  C;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire A_inv;
    wire B_inv;
    wire C_inv;

    // Inverter for A input
    not inv1 (
        A_inv,
        A
    );

    // Inverter for B input
    not inv2 (
        B_inv,
        B
    );

    // Inverter for C input
    not inv3 (
        C_inv,
        C
    );

    // AND gate implementation
    assign Z = A_inv & B_inv & C_inv;

endmodule