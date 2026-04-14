module decoder_4to16(
    input wire [3:0] A,
    output wire [15:0] Y
    );

assign Y = 16'b1 << A;

endmodule