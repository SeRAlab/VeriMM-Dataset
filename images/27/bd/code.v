module dynamic_range_compressor(
    input [4:0] in_signal,
    output reg [4:0] out_signal
);

always @(*) begin
    case (in_signal)
        5'b00000: out_signal = 5'b00000; // 0-1
        5'b00001: out_signal = 5'b00000; // 0-1
        5'b00010: out_signal = 5'b00001; // 2-3
        5'b00011: out_signal = 5'b00001; // 2-3
        5'b00100: out_signal = 5'b00010; // 4-5
        5'b00101: out_signal = 5'b00010; // 4-5
        5'b00110: out_signal = 5'b00011; // 6-7
        5'b00111: out_signal = 5'b00011; // 6-7
        5'b01000: out_signal = 5'b00100; // 8-9
        5'b01001: out_signal = 5'b00100; // 8-9
        5'b01010: out_signal = 5'b00101; // 10-11
        5'b01011: out_signal = 5'b00101; // 10-11
        5'b01100: out_signal = 5'b00110; // 12-13
        5'b01101: out_signal = 5'b00110; // 12-13
        5'b01110: out_signal = 5'b00111; // 14-15
        5'b01111: out_signal = 5'b00111; // 14-15
        5'b10000: out_signal = 5'b01000; // 16-17
        5'b10001: out_signal = 5'b01000; // 16-17
        5'b10010: out_signal = 5'b01001; // 18-19
        5'b10011: out_signal = 5'b01001; // 18-19
        5'b10100: out_signal = 5'b01010; // 20-21
        5'b10101: out_signal = 5'b01010; // 20-21
        5'b10110: out_signal = 5'b01011; // 22-23
        5'b10111: out_signal = 5'b01011; // 22-23
        5'b11000: out_signal = 5'b01100; // 24-25
        5'b11001: out_signal = 5'b01100; // 24-25
        5'b11010: out_signal = 5'b01101; // 26-27
        5'b11011: out_signal = 5'b01101; // 26-27
        5'b11100: out_signal = 5'b01110; // 28-29
        5'b11101: out_signal = 5'b01110; // 28-29
        5'b11110: out_signal = 5'b01111; // 30-31
        5'b11111: out_signal = 5'b01111; // 30-31
        default: out_signal = 5'b00000; // default case
    endcase
end
endmodule