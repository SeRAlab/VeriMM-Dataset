module or_128bit (
    input wire [127:0] a,
    input wire [127:0] b,
    output wire [127:0] y
);

    wire [31:0] y0, y1, y2, y3;

    or32 or32_inst0 (
        .a(a[31:0]),
        .b(b[31:0]),
        .y(y0)
    );

    or32 or32_inst1 (
        .a(a[63:32]),
        .b(b[63:32]),
        .y(y1)
    );

    or32 or32_inst2 (
        .a(a[95:64]),
        .b(b[95:64]),
        .y(y2)
    );

    or32 or32_inst3 (
        .a(a[127:96]),
        .b(b[127:96]),
        .y(y3)
    );

    assign y = {y3, y2, y1, y0};

endmodule

module or32 (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] y
);
    assign y = a | b;
endmodule