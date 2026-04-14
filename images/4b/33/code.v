module top_module(
    output out,
    input  in0, in1, in2, in3,
    input  [1:0] sel
);// Local signals
    wire not_sel0, not_sel1;
    wire sel0, sel1, sel2, sel3;

    // Invert the select signals
    not u_not_sel0 (not_sel0, sel[0]);
    not u_not_sel1 (not_sel1, sel[1]);

    // AND the inverted select signals with the input signals
    and u_sel0 (sel0, in0, not_sel0, not_sel1);
    and u_sel1 (sel1, in1, sel[0], not_sel1);
    and u_sel2 (sel2, in2, not_sel0, sel[1]);
    and u_sel3 (sel3, in3, sel[0], sel[1]);

    // OR the ANDed signals to get the output
    or u_out_or (out, sel0, sel1, sel2, sel3);

endmodule