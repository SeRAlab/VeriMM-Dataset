module bin_to_7seg (BIN, SEG);
input [2:0] BIN;
output reg [6:0] SEG;

always @(BIN) begin
    case (BIN)
        3'b000: SEG = 7'b0111111; // 0
        3'b001: SEG = 7'b0000110; // 1
        3'b010: SEG = 7'b1011011; // 2
        3'b011: SEG = 7'b1001111; // 3
        3'b100: SEG = 7'b1100110; // 4
        3'b101: SEG = 7'b1101101; // 5
        3'b110: SEG = 7'b1111101; // 6
        3'b111: SEG = 7'b0000111; // 7
        default: SEG = 7'b0000000; // Default case
    endcase
end

endmodule