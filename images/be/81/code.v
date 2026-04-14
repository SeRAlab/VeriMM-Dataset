module binary_subtractor(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire bin,
    output wire [7:0] diff,
    output wire bout
    );

assign {bout, diff} = {1'b0, a} - {1'b0, b} - bin;

endmodule