module binary_subtractor(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire bin,
    output wire [3:0] diff,
    output wire bout
    );

assign {bout, diff} = a - b - bin;

endmodule