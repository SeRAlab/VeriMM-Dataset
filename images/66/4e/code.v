module bin2gray (
    input wire [2:0] bin,
    output wire [2:0] gray
);

assign gray[2] = bin[2];
assign gray[1] = bin[2] ^ bin[1];
assign gray[0] = bin[1] ^ bin[0];

endmodule