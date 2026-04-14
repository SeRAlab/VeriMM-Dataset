module subtractor_8bit(
    input [7:0] a,
    input [7:0] b,
    input bin,
    output [7:0] diff,
    output bout
    );

    assign {bout, diff} = {1'b0, a} - {1'b0, b} - bin;
endmodule