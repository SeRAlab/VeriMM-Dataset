module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y
);wire and1_out;
    wire and2_out;

    and and1 (and1_out, A, B);
    and and2 (and2_out, C, D);
    and and3 (Y, and1_out, and2_out);

endmodule