module bin_to_gray(
    input [3:0] bin,
    output reg [3:0] gray
);

always @(*) begin
    gray[3] = bin[3];            // MSB remains the same
    gray[2] = bin[3] ^ bin[2];   // XOR MSB and next bit
    gray[1] = bin[2] ^ bin[1];   // XOR next two bits
    gray[0] = bin[1] ^ bin[0];   // XOR next two bits
end

endmodule