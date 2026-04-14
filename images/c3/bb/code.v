module my_module (
    input A1,
    input A2,
    input B1,
    input B2,
    output X
);

    wire and1_out;
    wire and2_out;
    wire not1_out;

    and and1 (and1_out, A1, A2);
    and and2 (and2_out, B1, B2);
    not not1 (not1_out, and2_out);

    assign X = and1_out & not1_out;

endmodule