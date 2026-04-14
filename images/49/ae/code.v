module decoder_2to4(
    input [1:0] a,      // 2-bit input signal

    output [3:0] y      // 4-bit output signal
);

// Decoder logic
assign y = (a == 2'b00) ? 4'b0001 :
           (a == 2'b01) ? 4'b0010 :
           (a == 2'b10) ? 4'b0100 :
                          4'b1000;

endmodule