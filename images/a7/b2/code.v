module bin_to_gray_2bit(
    input wire [1:0] bin,
    output wire [1:0] gray
    );

assign gray[1] = bin[1];
assign gray[0] = bin[1] ^ bin[0];

endmodule