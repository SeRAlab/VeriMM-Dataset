module top_module (
    input [3:0] bin,
    output [3:0] gray
);
    assign gray = bin ^ (bin >> 1);
endmodule