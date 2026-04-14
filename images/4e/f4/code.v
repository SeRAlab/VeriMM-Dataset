module top_module(
    input [15:0] bin,
    output [15:0] gray);

    assign gray = bin ^ (bin >> 1);

endmodule