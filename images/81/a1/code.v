module barrel_shifter_16bit (
    input wire [15:0] in,
    input wire [3:0] shift,
    input wire dir,
    output wire [15:0] out
);

    wire [15:0] part1, part2;

    barrel_shifter_8bit shifter1 (
        .in(in[15:8]),
        .shift(shift[2:0]),
        .dir(dir),
        .out(part1)
    );

    barrel_shifter_8bit shifter2 (
        .in(in[7:0]),
        .shift(shift[2:0]),
        .dir(dir),
        .out(part2)
    );

    assign out = dir ? {part1, part2} : {part2, part1};

endmodule

module barrel_shifter_8bit (
    input wire [7:0] in,
    input wire [2:0] shift,
    input wire dir,
    output wire [7:0] out
);

    assign out = dir ? in << shift : in >> shift;

endmodule