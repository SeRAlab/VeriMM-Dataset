module and_gate (
    input  a,
    input  b,
    input  en,
    output out
);

    // Output is high only when both inputs and enable are high
    assign out = (a & b & en);

endmodule