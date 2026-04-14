module top_module(
    //# {{data|Data Signals}}
    input  A1,
    input  A2,
    input  B1,
    input  C1,
    input  D1,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Intermediate signals
    wire and1_out;
    wire and2_out;
    wire and3_out;
    wire and4_out;
    wire or1_out;

    // AND gates
    and and1 (and1_out, A1, A2);
    and and2 (and2_out, B1, C1);
    and and3 (and3_out, C1, D1);
    and and4 (and4_out, and1_out, and2_out, and3_out);

    // OR gate
    or or1 (X, and4_out);

endmodule