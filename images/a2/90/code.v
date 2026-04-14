module top_module (
    input [3:0] bin,
    output [3:0] gray
);

    // Perform binary to Gray code conversion
    assign gray = (bin >> 1) ^ bin;

endmodule