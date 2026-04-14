module decoder_3to8(
    input wire [2:0] A,
    input wire EN,
    output wire [7:0] Y
    );

assign Y = EN ? (1 << A) : 8'b00000000;

endmodule