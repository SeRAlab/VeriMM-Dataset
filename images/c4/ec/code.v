module logic_module (
    input A1,
    input A2,
    input B1,
    output X
);

    // Local signals
    wire and_out ;
    wire or_out;

    //  Name  Output     Other arguments
    and and_gate (and_out , A1, A2);
    or  or_gate  (or_out, and_out, B1);
    assign X = or_out;

endmodule