module top_module(
    input  logic a,
    input  logic b,
    output logic y
);assign y = ~(a | b); // NOR operation
endmodule