module top_module(
    Y,
    A_N,
    B
);// Module ports
    output Y;
    input A_N;
    input B;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Local signals
    wire not0_out;
    wire not1_out;
    wire and0_out;

    //  Name  Output     Other arguments
    not not0 (not0_out, B);
    not not1 (not1_out, A_N);
    and and0 (and0_out, not0_out, not1_out);
    buf buf0 (Y, and0_out);

endmodule