module bin_to_gray_6bit(
    input [5:0] bin,
    output reg [5:0] gray
);

always @(*) begin
    gray[5] = bin[5];
    gray[4] = bin[5] ^ bin[4];
    gray[3] = bin[4] ^ bin[3];
    gray[2] = bin[3] ^ bin[2];
    gray[1] = bin[2] ^ bin[1];
    gray[0] = bin[1] ^ bin[0];
end

endmodule