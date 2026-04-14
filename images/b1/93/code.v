module bin_to_7seg(bin, seg);
    input [3:0] bin;
    output reg [6:0] seg;
    
    always @(bin) begin
        case(bin)
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
            4'b1011: seg = 7'b0011111; // b
            4'b1100: seg = 7'b1001110; // C
            4'b1101: seg = 7'b0111101; // d
            4'b1110: seg = 7'b1001111; // E
            4'b1111: seg = 7'b1000111; // F
            default: seg = 7'b0000000; // Default (blank)
        endcase
    end
endmodule