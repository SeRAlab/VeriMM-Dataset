module top_module(
    input [3:0] in,
    output reg [6:0] seg,
    output reg dp,
    output reg [3:0] an
);// Binary-to-BCD converter
    wire [3:0] bcd;
    assign bcd = (in >= 8) ? 8'b1000 : (in >= 4) ? 8'b0100 : (in >= 2) ? 8'b0010 : (in >= 1) ? 8'b0001 : 8'b0000;

    // BCD-to-seven-segment decoder
    always @(*) begin
        case (bcd)
            4'b0000: seg = 7'b1111110; // 0
            4'b0001: seg = 7'b0110000; // 1
            4'b0010: seg = 7'b1101101; // 2
            4'b0011: seg = 7'b1111001; // 3
            4'b0100: seg = 7'b0110011; // 4
            4'b0101: seg = 7'b1011011; // 5
            4'b0110: seg = 7'b1011111; // 6
            4'b0111: seg = 7'b1110000; // 7
            4'b1000: seg = 7'b1111111; // 8
            4'b1001: seg = 7'b1111011; // 9
            4'b1010: seg = 7'b1110111; // A
            4'b1011: seg = 7'b0011111; // B
            4'b1100: seg = 7'b1001110; // C
            4'b1101: seg = 7'b0111101; // D
            4'b1110: seg = 7'b1001111; // E
            4'b1111: seg = 7'b1000111; // F
            default: seg = 7'b0000000; // Error
        endcase
    end

    // Priority encoder
    always @(*) begin
        case (in)
            4'b1000: an = 4'b1000; // Highest-order bit is in position 3
            4'b0100: an = 4'b0100; // Highest-order bit is in position 2
            4'b0010: an = 4'b0010; // Highest-order bit is in position 1
            4'b0001: an = 4'b0001; // Highest-order bit is in position 0
            default: an = 4'b0000; // None of the input bits are high
        endcase
    end

    // Display decimal point if highest-order bit is set
    always @(*) begin
        dp = (in >= 8) ? 1'b1 : 1'b0;
    end

endmodule