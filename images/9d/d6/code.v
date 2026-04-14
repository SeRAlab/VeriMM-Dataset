module top_module(
    in0,
    in1,
    in2,
    in3,
    sel0,
    sel1,
    out
);input in0, in1, in2, in3, sel0, sel1;
    output out;
    wire and1, and2, and3, and4;

    // Use basic AND gates instead of unknown sky130_fd_sc_hd__and4bb_1 gates
    wire sel0_n, sel1_n;
    not (sel0_n, sel0);
    not (sel1_n, sel1);

    and (and1, sel1_n, sel0_n, in0);
    and (and2, sel1_n, sel0, in1);
    and (and3, sel1, sel0_n, in2);
    and (and4, sel1, sel0, in3);

    assign out = and1 | and2 | and3 | and4;

endmodule