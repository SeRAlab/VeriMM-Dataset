module top_module(
    X,
    A_N,
    B,
    C,
    D
);// Module ports
    output X;
    input A_N;
    input B;
    input C;
    input D;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Local signals
    wire not0_out;
    wire and0_out;
    wire and1_out;

    //  Name  Output      Other arguments
    not not0 (not0_out, A_N);
    and and0 (and0_out, B, C);
    and and1 (and1_out, not0_out, D, and0_out);
    buf buf0 (X, and1_out);

endmodule