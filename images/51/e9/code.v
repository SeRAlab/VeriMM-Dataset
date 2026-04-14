module top_module(
    A,
    B,
    C,
    D,
    Y
);// Module ports
    input  A;
    input  B;
    input  C;
    input  D;
    output Y;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire and0_out;
    wire and1_out;
    wire and2_out;
    wire and3_out;

    // Implement a 3-input AND gate using two 2-input AND gates
    and and0 (and0_out, A, B);
    and and1 (and1_out, and0_out, C);

    // Implement another 3-input AND gate using two 2-input AND gates
    and and2 (and2_out, B, C);
    and and3 (and3_out, and2_out, D);

    // Invert the output of one of the 3-input AND gates
    not not0 (and2_out_inv, and2_out);

    // AND the outputs of the two 3-input AND gates
    and and4 (and4_out, and1_out, and2_out_inv);

    // Invert the output of the AND gate from step 4
    not not1 (Y, and4_out);

endmodule