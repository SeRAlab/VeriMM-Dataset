module top_module(
    in0,
    in1,
    in2,
    in3,
    sel,
    out
);// Inputs
    input in0;
    input in1;
    input in2;
    input in3;
    input sel;

    // Outputs
    output out;

    // Internal signals
    wire sel0;
    wire sel1;
    wire sel2;
    wire sel3;

    // Implement the select lines
    assign sel0 = ~sel & ~sel & ~sel;
    assign sel1 = ~sel & ~sel & sel;
    assign sel2 = ~sel & sel & ~sel;
    assign sel3 = sel & ~sel & ~sel;

    // Implement the multiplexer
    assign out = (sel0 & in0) | (sel1 & in1) | (sel2 & in2) | (sel3 & in3);

endmodule