module bin_to_gray_4bit(
    input  [3:0] bin,
    output [3:0] gray
);

assign gray = {bin[3], bin[3] ^ bin[2], bin[2] ^ bin[1], bin[1] ^ bin[0]};

endmodule