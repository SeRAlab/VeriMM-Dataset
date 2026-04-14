module huffman_encoder (
    input [3:0] char_in,
    output reg [7:0] encoded_out
);
    always @(*) begin
        case(char_in)
            4'b0000: encoded_out = 8'b00000000; // 0 -> 000
            4'b0001: encoded_out = 8'b00000001; // 1 -> 001
            4'b0010: encoded_out = 8'b00000010; // 2 -> 010
            4'b0011: encoded_out = 8'b00000011; // 3 -> 011
            4'b0100: encoded_out = 8'b00000100; // 4 -> 100
            4'b0101: encoded_out = 8'b00000101; // 5 -> 101
            4'b0110: encoded_out = 8'b00000110; // 6 -> 110
            4'b0111: encoded_out = 8'b00000111; // 7 -> 111
            4'b1000: encoded_out = 8'b00001000; // 8 -> 00
            4'b1001: encoded_out = 8'b00001001; // 9 -> 01
            4'b1010: encoded_out = 8'b00001010; // 10 -> 10
            4'b1011: encoded_out = 8'b00001011; // 11 -> 11
            4'b1100: encoded_out = 8'b00010000; // 12 -> 00000
            4'b1101: encoded_out = 8'b00010001; // 13 -> 00001
            4'b1110: encoded_out = 8'b00010010; // 14 -> 00010
            4'b1111: encoded_out = 8'b00010011; // 15 -> 00011
            default: encoded_out = 8'b00000000; // invalid input
        endcase
    end
endmodule