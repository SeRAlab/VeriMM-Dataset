module top_module(
    input A1,
    input A2,
    input A3,
    input A4,
    input B1,
    output X
);wire and1_out, and2_out, and3_out, and4_out, and5_out;

    and and1 (and1_out, A1, A2);
    and and2 (and2_out, and1_out, A3);
    and and3 (and3_out, and2_out, A4);
    and and4 (and4_out, and3_out, B1);
    and and5 (X, and4_out);

endmodule