module decoder_2to4(
    input [1:0] in,   // 2-bit binary input.

    output [3:0] out  // 4-bit one-hot output.
);

assign out = (in == 2'b00) ? 4'b0001 :
             (in == 2'b01) ? 4'b0010 :
             (in == 2'b10) ? 4'b0100 :
             (in == 2'b11) ? 4'b1000 : 4'b0000;

endmodule