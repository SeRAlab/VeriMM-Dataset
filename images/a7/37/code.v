module top_module(
    in0,
    in1,
    in2,
    in3,
    s0,
    s1,
    vpwr,
    vgnd,
    out
);input in0, in1, in2, in3, s0, s1, vpwr, vgnd;
    output out;

    wire w1, w2, w3, w4;

    // Use basic logic gates instead of unknown module
    wire s0_n, s1_n;
    not n1(s0_n, s0);
    not n2(s1_n, s1);

    and and2_0(w1, in0, s1_n);
    and and2_1(w2, in1, s0_n, s1);
    and and2_2(w3, in2, s0, s1_n);
    and and2_3(w4, in3, s0, s1);
    
    or or1(out, w1, w2, w3, w4);

endmodule