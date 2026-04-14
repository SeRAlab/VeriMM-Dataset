module decoder_2to4(
    input wire [1:0] A,
    output wire [3:0] Y
    );

assign Y = 4'b1 << A;

endmodule