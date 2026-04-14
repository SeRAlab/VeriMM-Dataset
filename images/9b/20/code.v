module top_module(
    X,
    A1,
    A2,
    A3,
    B1,
    B2
);// Module ports
    output X;
    input A1;
    input A2;
    input A3;
    input B1;
    input B2;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Local signals
    wire or0_out;
    wire or1_out;
    wire or2_out;
    wire or3_out;
    wire or4_out;
    wire and0_out;
    wire and1_out;
    wire and2_out;

    // Logic
    or or0(or0_out, A1, A2);
    or or1(or1_out, A1, A3);
    or or2(or2_out, A2, A3);
    or or3(or3_out, B1, B2);
    or or4(or4_out, or0_out, or1_out, or2_out);
    and and0(and0_out, or0_out, or1_out);
    and and1(and1_out, or0_out, or2_out);
    and and2(and2_out, or1_out, or2_out);
    or or5(X, or3_out, and0_out, and1_out, and2_out, or4_out);

endmodule