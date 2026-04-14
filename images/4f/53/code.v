module decoder_3to8(
    input wire [2:0] sel,
    output wire [7:0] out
);

    assign out = 1 << sel;

endmodule