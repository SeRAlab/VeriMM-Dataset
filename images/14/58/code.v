module huffman_encoder (
    input [3:0] char,
    output reg [5:0] code
);
    always @(*) begin
        case (char)
            4'b0000: code = 6'b000000; // 0
            4'b0001: code = 6'b000010; // 10
            4'b0010: code = 6'b000110; // 110
            4'b0011: code = 6'b001110; // 1110
            4'b0100: code = 6'b001111; // 1111
            4'b0101: code = 6'b001100; // 1100
            4'b0110: code = 6'b0011100; // 11100
            4'b0111: code = 6'b0011101; // 11101
            4'b1000: code = 6'b0011110; // 111110
            4'b1001: code = 6'b0011111; // 111111
            4'b1010: code = 6'b0011000; // 11000
            4'b1011: code = 6'b0011001; // 11001
            4'b1100: code = 6'b001010; // 1010
            4'b1101: code = 6'b001011; // 1011
            4'b1110: code = 6'b001000; // 1000
            4'b1111: code = 6'b001001; // 1001
            default: code = 6'b000000; // Not mapped
        endcase
    end
endmodule