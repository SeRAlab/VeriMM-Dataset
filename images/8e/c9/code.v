module top_module(
    in0,
    in1,
    in2,
    in3,
    sel1,
    sel0,
    out
);input in0;
    input in1;
    input in2;
    input in3;
    input sel1;
    input sel0;
    output out;

    wire not_sel1;
    wire not_sel0;
    wire and1;
    wire and2;
    wire and3;
    wire and4;

    // Invert select wires
    not not_gate1(not_sel1, sel1);
    not not_gate2(not_sel0, sel0);

    // AND gates to create all possible combinations
    and and_gate1(and1, in0, not_sel1, not_sel0);
    and and_gate2(and2, in1, not_sel1, sel0);
    and and_gate3(and3, in2, sel1, not_sel0);
    and and_gate4(and4, in3, sel1, sel0);

    // OR gate to combine the AND gates
    or or_gate(out, and1, and2, and3, and4);

endmodule