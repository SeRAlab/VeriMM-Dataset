module seven_segment_decoder(bin_input, seg_output);
input [3:0] bin_input;
output reg [6:0] seg_output;

always@(bin_input) begin
    case(bin_input)
        4'b0000: seg_output = 7'b0111111; // 0
        4'b0001: seg_output = 7'b0000110; // 1
        4'b0010: seg_output = 7'b1011011; // 2
        4'b0011: seg_output = 7'b1001111; // 3
        4'b0100: seg_output = 7'b1100110; // 4
        4'b0101: seg_output = 7'b1101101; // 5
        4'b0110: seg_output = 7'b1111101; // 6
        4'b0111: seg_output = 7'b0000111; // 7
        4'b1000: seg_output = 7'b1111111; // 8
        4'b1001: seg_output = 7'b1101111; // 9
        4'b1010: seg_output = 7'b1110111; // A
        4'b1011: seg_output = 7'b1111100; // b
        4'b1100: seg_output = 7'b0111001; // C
        4'b1101: seg_output = 7'b1011110; // d
        4'b1110: seg_output = 7'b1111001; // E
        4'b1111: seg_output = 7'b1110001; // F
        default: seg_output = 7'b0000000; // Default (all segments off)
    endcase
end

endmodule