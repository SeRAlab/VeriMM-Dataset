module decoder_3to8 (
    input [2:0] in,
    output [7:0] out
);

assign out = 8'b00000001 << in;

endmodule