module decoder_2to4(
    input wire [1:0] sel,
    output wire [3:0] out
);

    assign out = 1 << sel;

endmodule