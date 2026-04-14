module top_module(
    in1,
    in2,
    in3,
    in4,
    in5,
    in6,
    in7,
    out
);input [6:0] in1, in2, in3, in4, in5, in6, in7;
    output out;

    wire and1, and2, and3, and4, and5, and6;

    and and_gate1(and1, in1[0], in2[0], in3[0], in4[0], in5[0], in6[0], in7[0]);
    and and_gate2(and2, in1[1], in2[1], in3[1], in4[1], in5[1], in6[1], in7[1]);
    and and_gate3(and3, in1[2], in2[2], in3[2], in4[2], in5[2], in6[2], in7[2]);
    and and_gate4(and4, in1[3], in2[3], in3[3], in4[3], in5[3], in6[3], in7[3]);
    and and_gate5(and5, in1[4], in2[4], in3[4], in4[4], in5[4], in6[4], in7[4]);
    and and_gate6(and6, in1[5], in2[5], in3[5], in4[5], in5[5], in6[5], in7[5]);

    or or_gate(out, and1, and2, and3, and4, and5, and6);

endmodule