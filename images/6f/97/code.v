module barrel_shifter_32bit (
    input wire [31:0] a,
    input wire [4:0] shift,
    input wire direction,
    output wire [31:0] y
);

    wire [31:0] stage0, stage1, stage2, stage3;

    barrel_shifter8 barrel_shifter8_inst0 (
        .a(a),
        .shift(shift[2:0]),
        .direction(direction),
        .y(stage0)
    );

    barrel_shifter8 barrel_shifter8_inst1 (
        .a(stage0),
        .shift({2'b00, shift[3]}),
        .direction(direction),
        .y(stage1)
    );

    barrel_shifter8 barrel_shifter8_inst2 (
        .a(stage1),
        .shift({3'b000, shift[4]}),
        .direction(direction),
        .y(stage2)
    );

    assign y = stage2;

endmodule

module barrel_shifter8 (
    input wire [31:0] a,
    input wire [2:0] shift,
    input wire direction,
    output wire [31:0] y
);
    wire [31:0] left_shift, right_shift;

    assign left_shift = a << shift;
    assign right_shift = a >> shift;

    assign y = direction ? right_shift : left_shift;
endmodule