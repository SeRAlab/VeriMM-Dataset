module top_module(
    A,
    B,
    Sel,
    Y
);// Module ports
    input A;
    input B;
    input Sel;
    output Y;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire not_Sel;
    wire and0_out;
    wire and1_out;
    wire or0_out;
    wire xor0_out;
    wire xor1_out;

    //  Name  Output      Other arguments
    not not0 (not_Sel, Sel      );
    and and0 (and0_out, A, not_Sel);
    and and1 (and1_out, B, Sel    );
    or  or0  (or0_out , and0_out, and1_out);
    xor xor0 (xor0_out, A, B     );
    xor xor1 (xor1_out, xor0_out, or0_out);

    assign Y = xor1_out;

endmodule