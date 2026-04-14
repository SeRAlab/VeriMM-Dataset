module binary_to_gray
    (
        input [4:0] bin,
        output [4:0] gray
    );

    assign gray = bin ^ (bin >> 1);

endmodule