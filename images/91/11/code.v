module top_module(
    out,
    a,
    b,
    c,
    d
);// Module ports
    output out;
    input a;
    input b;
    input c;
    input d;

    // Module supplies (not typically needed for simple combinational logic, can be removed)
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Local signals
    wire xor1_out;
    wire xor2_out;

    // Implementing a 4-input XOR using two stages
    xor xor1 (xor1_out, a, b);
    xor xor2 (xor2_out, c, d);
    xor xor_final (out, xor1_out, xor2_out);

endmodule