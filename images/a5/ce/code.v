module decoder_6to64(
    input wire [5:0] A,
    output wire [63:0] Y
    );

assign Y = 64'b1 << A;

endmodule