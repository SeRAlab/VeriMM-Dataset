module multiplier_8bit (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [15:0] y
);

    wire [15:0] part1, part2, part3, part4;

    mult4 mult4_inst1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .y(part1)
    );

    mult4 mult4_inst2 (
        .a(a[7:4]),
        .b(b[3:0]),
        .y(part2)
    );

    mult4 mult4_inst3 (
        .a(a[3:0]),
        .b(b[7:4]),
        .y(part3)
    );

    mult4 mult4_inst4 (
        .a(a[3:0]),
        .b(b[3:0]),
        .y(part4)
    );

    assign y = part1 + (part2 << 4) + (part3 << 4) + (part4 << 8);

endmodule

module mult4 (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [7:0] y
);
    assign y = a * b;
endmodule