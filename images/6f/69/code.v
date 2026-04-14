module decoder_1to2(
    input wire A,
    output wire [1:0] Y
    );

assign Y = 2'b1 << A;

endmodule