module and_gate_with_enable(
    input  a,
    input  b,
    input  en,
    output y
);

assign y = en ? (a & b) : 1'b0;

endmodule