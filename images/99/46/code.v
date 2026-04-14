module multiplier_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [63:0] y
);

    wire [63:0] p0, p1, p2, p3;

    multiplier_16bit mult_inst1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .y(p0)
    );

    multiplier_16bit mult_inst2 (
        .a(a[31:16]),
        .b(b[15:0]),
        .y(p1)
    );

    multiplier_16bit mult_inst3 (
        .a(a[15:0]),
        .b(b[31:16]),
        .y(p2)
    );

    multiplier_16bit mult_inst4 (
        .a(a[15:0]),
        .b(b[15:0]),
        .y(p3)
    );

    assign y = p0 + (p1 << 16) + (p2 << 16) + p3;

endmodule

module multiplier_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [31:0] y
);

    wire [31:0] p0, p1, p2, p3;

    multiplier_8bit mult_inst1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .y(p0)
    );

    multiplier_8bit mult_inst2 (
        .a(a[15:8]),
        .b(b[7:0]),
        .y(p1)
    );

    multiplier_8bit mult_inst3 (
        .a(a[7:0]),
        .b(b[15:8]),
        .y(p2)
    );

    multiplier_8bit mult_inst4 (
        .a(a[7:0]),
        .b(b[7:0]),
        .y(p3)
    );

    assign y = p0 + (p1 << 8) + (p2 << 8) + p3;

endmodule

module multiplier_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [15:0] y
);

    wire [15:0] p0, p1, p2, p3;

    multiplier_4bit mult_inst1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .y(p0)
    );

    multiplier_4bit mult_inst2 (
        .a(a[7:4]),
        .b(b[3:0]),
        .y(p1)
    );

    multiplier_4bit mult_inst3 (
        .a(a[3:0]),
        .b(b[7:4]),
        .y(p2)
    );

    multiplier_4bit mult_inst4 (
        .a(a[3:0]),
        .b(b[3:0]),
        .y(p3)
    );

    assign y = p0 + (p1 << 4) + (p2 << 4) + p3;

endmodule

module multiplier_4bit (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [7:0] y
);

    wire [7:0] p0, p1, p2, p3;

    multiplier_2bit mult_inst1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .y(p0)
    );

    multiplier_2bit mult_inst2 (
        .a(a[3:2]),
        .b(b[1:0]),
        .y(p1)
    );

    multiplier_2bit mult_inst3 (
        .a(a[1:0]),
        .b(b[3:2]),
        .y(p2)
    );

    multiplier_2bit mult_inst4 (
        .a(a[1:0]),
        .b(b[1:0]),
        .y(p3)
    );

    assign y = p0 + (p1 << 2) + (p2 << 2) + p3;

endmodule

module multiplier_2bit (
    input wire [1:0] a,
    input wire [1:0] b,
    output wire [3:0] y
);

    assign y = a * b;

endmodule