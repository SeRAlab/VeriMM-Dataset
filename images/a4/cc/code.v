module decoder_3to8(
    input wire [2:0] A,
    output wire [7:0] Y
    );

assign Y = 8'b1 << A;

endmodule