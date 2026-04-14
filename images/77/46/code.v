module bcd_to_7seg(BCD, SEG);
input [3:0] BCD;
output reg [6:0] SEG;

always @(BCD) begin
    case (BCD)
        4'b0000: SEG = 7'b0111111; // 0
        4'b0001: SEG = 7'b0000110; // 1
        4'b0010: SEG = 7'b1011011; // 2
        4'b0011: SEG = 7'b1001111; // 3
        4'b0100: SEG = 7'b1100110; // 4
        4'b0101: SEG = 7'b1101101; // 5
        4'b0110: SEG = 7'b1111101; // 6
        4'b0111: SEG = 7'b0000111; // 7
        4'b1000: SEG = 7'b1111111; // 8
        4'b1001: SEG = 7'b1101111; // 9
        default: SEG = 7'b0000000; // Default to 0
    endcase
end

endmodule