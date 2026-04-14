module subtractor_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] diff
);

    wire [7:0] diff0, diff1, diff2, diff3;
    wire b_out1, b_out2, b_out3;

    subtractor8 subtractor8_inst0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .bin(1'b0),
        .diff(diff0),
        .bout(b_out1)
    );

    subtractor8 subtractor8_inst1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .bin(b_out1),
        .diff(diff1),
        .bout(b_out2)
    );

    subtractor8 subtractor8_inst2 (
        .a(a[23:16]),
        .b(b[23:16]),
        .bin(b_out2),
        .diff(diff2),
        .bout(b_out3)
    );

    subtractor8 subtractor8_inst3 (
        .a(a[31:24]),
        .b(b[31:24]),
        .bin(b_out3),
        .diff(diff3),
        .bout()
    );

    assign diff = {diff3, diff2, diff1, diff0};

endmodule

module subtractor8 (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire bin,
    output wire [7:0] diff,
    output wire bout
);
    assign {bout, diff} = {1'b0, a} - {1'b0, b} - bin;
endmodule