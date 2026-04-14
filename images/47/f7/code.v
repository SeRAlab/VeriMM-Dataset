module and_64bit (
    input wire [63:0] a,
    input wire [63:0] b,
    output wire [63:0] y
);

    wire [15:0] y0, y1, y2, y3;

    and16 and16_inst0 (
        .a(a[15:0]),
        .b(b[15:0]),
        .y(y0)
    );

    and16 and16_inst1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .y(y1)
    );

    and16 and16_inst2 (
        .a(a[47:32]),
        .b(b[47:32]),
        .y(y2)
    );

    and16 and16_inst3 (
        .a(a[63:48]),
        .b(b[63:48]),
        .y(y3)
    );

    assign y = {y3, y2, y1, y0};

endmodule

module and16 (
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] y
);
    assign y = a & b;
endmodule