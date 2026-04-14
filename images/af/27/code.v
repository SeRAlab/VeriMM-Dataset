module top_module(
    input [2:0] in,
    output [7:0] out
);

    assign out = 1 << in;  // 3-to-8 decoder

endmodule