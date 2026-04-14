module xor_256bit (
    input wire [255:0] a,
    input wire [255:0] b,
    output wire [255:0] y
);

    wire [63:0] y0, y1, y2, y3;

    xor64 xor64_inst0 (
        .a(a[63:0]),
        .b(b[63:0]),
        .y(y0)
    );

    xor64 xor64_inst1 (
        .a(a[127:64]),
        .b(b[127:64]),
        .y(y1)
    );

    xor64 xor64_inst2 (
        .a(a[191:128]),
        .b(b[191:128]),
        .y(y2)
    );

    xor64 xor64_inst3 (
        .a(a[255:192]),
        .b(b[255:192]),
        .y(y3)
    );

    assign y = {y3, y2, y1, y0};

endmodule

module xor64 (
    input wire [63:0] a,
    input wire [63:0] b,
    output wire [63:0] y
);
    assign y = a ^ b;
endmodule