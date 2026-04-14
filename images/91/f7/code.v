module top_module(
    A,
    B,
    C,
    D,
    Y
);// Module ports
    input  A, B, C, D;
    output Y;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire  not_A_wire, not_B_wire, not_C_wire, not_D_wire;
    wire  and1_out, and2_out;

    //  Name  Output      Other arguments
    not not_A (not_A_wire, A);
    not not_B (not_B_wire, B);
    not not_C (not_C_wire, C);
    not not_D (not_D_wire, D);

    and and1 (and1_out, not_A_wire, not_B_wire);
    and and2 (and2_out, not_C_wire, not_D_wire);
    and and3 (Y, and1_out, and2_out);

endmodule