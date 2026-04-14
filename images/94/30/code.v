module seven_segment_decoder(
    input [3:0] digit,
    output reg [6:0] segments);always @(*) begin
    case (digit)
        4'b0000: segments = 7'b0111111; // 0
        4'b0001: segments = 7'b0000110; // 1
        4'b0010: segments = 7'b1011011; // 2
        4'b0011: segments = 7'b1001111; // 3
        4'b0100: segments = 7'b1100110; // 4
        4'b0101: segments = 7'b1101101; // 5
        4'b0110: segments = 7'b1111101; // 6
        4'b0111: segments = 7'b0000111; // 7
        4'b1000: segments = 7'b1111111; // 8
        4'b1001: segments = 7'b1101111; // 9
        4'b1010: segments = 7'b1110111; // A
        4'b1011: segments = 7'b1111100; // B
        4'b1100: segments = 7'b0111001; // C
        4'b1101: segments = 7'b1011110; // D
        4'b1110: segments = 7'b1111001; // E
        4'b1111: segments = 7'b1110001; // F
        default: segments = 7'b0000000; // off
    endcase
end
endmodule