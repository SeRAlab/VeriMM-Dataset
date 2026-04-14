module my_module (
    input A1,
    input A2,
    input A3,
    input B1,
    input B2,
    output X
);

    wire and0_out;
    wire and1_out;
    wire or0_out_X;

    and and0 (and0_out, A1, A2, A3);
    and and1 (and1_out, B1, B2);
    or or0 (or0_out_X, and0_out, and1_out);
    buf buf0 (X, or0_out_X);

endmodule