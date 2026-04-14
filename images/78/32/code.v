module top_module(
    input in0,
    input in1,
    input sel,
    output o
    );assign o = ((~sel & in0)|(sel & in1));

endmodule