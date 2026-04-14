module top_module(
    in1,
    in2,
    en,
    out,
    out_valid
);input in1;
    input in2;
    input en;
    output out;
    output out_valid;

    wire and_out;

    and and_gate(and_out, in1, in2);

    assign out = and_out & en;
    assign out_valid = en;

endmodule