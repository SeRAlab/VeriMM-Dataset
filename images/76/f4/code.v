module top_module(
    input [7:0] bin,
    output [7:0] gray);assign gray[7] = bin[7];
assign gray[6] = bin[7] ^ bin[6];
assign gray[5] = bin[6] ^ bin[5];
assign gray[4] = bin[5] ^ bin[4];
assign gray[3] = bin[4] ^ bin[3];
assign gray[2] = bin[3] ^ bin[2];
assign gray[1] = bin[2] ^ bin[1];
assign gray[0] = bin[1] ^ bin[0];

endmodule