module top_module(
    input logic a,
    input logic b,
    input logic sel,
    output logic out
);assign out = (!sel & a) | (sel & b);

endmodule