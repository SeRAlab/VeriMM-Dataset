module top_module(
    input [3:0] bin,
    output [3:0] tens,
    output [3:0] ones
);

    // Convert binary to BCD
    assign tens = (bin >= 10) ? 1 : 0;
    assign ones = (bin >= 10) ? (bin - 10) : bin;

endmodule