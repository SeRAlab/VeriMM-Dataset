module top_module(
    input wire [3:0] bin,
    output wire [3:0] gray
);

    assign gray = (bin >> 1) ^ bin;

endmodule